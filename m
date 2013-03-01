Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3CAPmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:42:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3CAPma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:42:30 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] printk: add CON_ALLDATA console flag
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
	<1362087602-8979-4-git-send-email-joern@logfs.org>
	<x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
	<20130301145805.GC30938@pd.tnic>
	<x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
	<20130301153100.GD30938@pd.tnic>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 01 Mar 2013 10:42:16 -0500
In-Reply-To: <20130301153100.GD30938@pd.tnic> (Borislav Petkov's message of
	"Fri, 1 Mar 2013 16:31:00 +0100")
Message-ID: <x49621b2kkn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Fri, Mar 01, 2013 at 10:08:00AM -0500, Jeff Moyer wrote:
>> People don't just use this for "debugging sessions." They use it in
>> production, and I already gave you one reason why you might not want
>> to do this with netconsole (udp is unreliable, and I've definitely
>> seem cases where netconsole suffered due to dropped packets; this
>> won't make that better, especially when you multiply the extra bytes
>> times the number of servers on the subnet).
>
> Ok, so we probably need to drop 4/9 for netconsole.

I don't think you've provided a very strong case for ignoring the
administrator's configuration settings.  I'm against the patches that
introduce this behaviour, for whatever that's worth (2 cents is the
going rate, I think).

Cheers,
Jeff
