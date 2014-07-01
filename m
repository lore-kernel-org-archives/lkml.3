Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbaGANoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:44:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38584 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbaGANoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:44:21 -0400
Date: Tue, 1 Jul 2014 15:44:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kelvin Gonzalez <kelvin.gonzalezvivas@gmail.com>
Cc: =?utf-8?B?J0rDtnJnIFLDtmRlbCc=?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Desktop PC freezes after showing many times the lines "AMD-Vi:
 Completion-Wait loop timed out" and "BUG: soft lockup - CPU#2 stuck for
 23s!"
Message-ID: <20140701134415.GA5438@pd.tnic>
References: <!&!AAAAAAAAAAAYAAAAAAAAANg+Q8tI5MNHj6qGz8No2F8igQAAEAAAANPhKY0kKNJJiL8MIUQYNFkBAAAAAA==@gmail.com>
 <20140629093818.GA5427@pd.tnic>
 <20140630081340.GB26537@8bytes.org>
 <006a01cf9530$b3117bb0$19347310$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <006a01cf9530$b3117bb0$19347310$@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kelvin,

On Tue, Jul 01, 2014 at 03:30:59PM +0200, Kelvin Gonzalez wrote:
> Thank you Joerg and Borislav,

sure, np.

Btw, please do not top-post when replying to that thread.

> There is no BIOS Update available for this Mother Board. It has the most
> recent from Jan 2014. And I didn't find any option available in the BIOS
> Menu to disable the IOMMU.
> 
> I tried yesterday a fresh install passing the 'amd_iommu=off' to the kernel
> and everything is working fine. No delays/hangs, etc. The workaround works
> just perfect.

Well, this disables the IOMMU on your machine and it works perfectly
because you're simply not using it anymore. :-)

If you get a BIOS update at some point and/or want to complain to the
board manufacturer to give you a BIOS update and to fix the IOMMU setup,
you could try to enable it again (i.e., remove the cmdline option) and
report back to us.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
