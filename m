Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab3CAPbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:31:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55494 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3CAPbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:31:11 -0500
Date: Fri, 1 Mar 2013 16:31:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] printk: add CON_ALLDATA console flag
Message-ID: <20130301153100.GD30938@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Moyer <jmoyer@redhat.com>, Joern Engel <joern@logfs.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-4-git-send-email-joern@logfs.org>
 <x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
 <20130301145805.GC30938@pd.tnic>
 <x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 10:08:00AM -0500, Jeff Moyer wrote:
> People don't just use this for "debugging sessions." They use it in
> production, and I already gave you one reason why you might not want
> to do this with netconsole (udp is unreliable, and I've definitely
> seem cases where netconsole suffered due to dropped packets; this
> won't make that better, especially when you multiply the extra bytes
> times the number of servers on the subnet).

Ok, so we probably need to drop 4/9 for netconsole.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
