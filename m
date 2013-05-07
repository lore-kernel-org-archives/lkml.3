Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab3EGVj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:39:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33692 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759556Ab3EGVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:39:55 -0400
Date: Tue, 7 May 2013 23:41:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: MFD_TPS65912 needs MFD_CORE
Message-ID: <20130507214103.GA25868@pd.tnic>
References: <1366373156-24248-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1366373156-24248-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 02:05:56PM +0200, Michal Marek wrote:
> With MFD_TPS65912=y and MFD_CORE=m/n, the build fails with
> 
> drivers/mfd/tps65912-core.c:147: undefined reference to `mfd_add_devices'
> drivers/mfd/tps65912-core.c:164: undefined reference to `mfd_remove_devices'
> drivers/mfd/tps65912-core.c:171: undefined reference to `mfd_remove_devices'
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Borislav Petkov <bp@suse.de>

Looks like this one is not upstream yet - just triggered it on a
randconfig build of current linus.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
