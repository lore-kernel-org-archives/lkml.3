Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab3KHRBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:01:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51202 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab3KHRBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:01:39 -0500
Message-ID: <1383929654.32324.27.camel@fishsauce>
Subject: Re: [tpmdd-devel] tpm: Remainder of earlier clean up
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Nov 2013 10:54:14 -0600
In-Reply-To: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110817-7182-0000-0000-0000090C78D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
 Just want to let you know that I'm not forgetting about reviewing these
patches.  It is on my to do list, I will get to it by this or next
weekend.

--Ashley Lai

On Sun, 2013-11-03 at 20:38 -0700, Jason Gunthorpe wrote:
> Here is the last five patches from the prior series I sent that didn't get
> picked up yet.
> 
> There are no changes, these are just rebased onto 3.12rc7 + Peter's for-james
> branch. (Peter: Note, there are TPM changes to the Xen driver in 3.12rc7 that
> are not in your for-james branch)
> 
> The intent of these patches is to reduce the duplicated code that is present
> in all the drivers by migrating it into the core.
> 
> I've placed the patches on my github:
>  https://github.com/jgunthorpe/linux/commits/for-tpm
> 
>  drivers/char/tpm/Makefile           |    2 +-
>  drivers/char/tpm/tpm-dev.c          |  213 +++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm-interface.c    |  487 +++++-------------------------------------------------------------------------------
>  drivers/char/tpm/tpm-sysfs.c        |  318 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm.h              |   83 +++++++--------
>  drivers/char/tpm/tpm_atmel.c        |   28 +----
>  drivers/char/tpm/tpm_i2c_atmel.c    |   42 +-------
>  drivers/char/tpm/tpm_i2c_infineon.c |   42 +-------
>  drivers/char/tpm/tpm_i2c_nuvoton.c  |   42 +-------
>  drivers/char/tpm/tpm_i2c_stm_st33.c |   41 +------
>  drivers/char/tpm/tpm_ibmvtpm.c      |   40 +------
>  drivers/char/tpm/tpm_infineon.c     |   28 +----
>  drivers/char/tpm/tpm_nsc.c          |   28 +----
>  drivers/char/tpm/tpm_tis.c          |   49 +--------
>  drivers/char/tpm/xen-tpmfront.c     |   45 +-------
>  include/linux/tpm.h                 |   12 +++
>  16 files changed, 624 insertions(+), 876 deletions(-)
> 
> 
> ------------------------------------------------------------------------------
> Android is increasing in popularity, but the open development platform that
> developers love is also attractive to malware creators. Download this white
> paper to learn more about secure code signing practices that can help keep
> Android apps secure.
> http://pubads.g.doubleclick.net/gampad/clk?id=65839951&iu=/4140/ostg.clktrk
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> 


