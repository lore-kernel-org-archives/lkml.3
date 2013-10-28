Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab3J1PMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:12:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620Ab3J1PMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:12:02 -0400
Date: Mon, 28 Oct 2013 23:10:48 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
 <20131028093206.GB4314@pd.tnic>
 <20131028094049.GC25527@dhcp-16-126.nay.redhat.com>
 <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
 <20131028100402.GC4314@pd.tnic>
 <20131028101011.GF25527@dhcp-16-126.nay.redhat.com>
 <20131028112045.GH4314@pd.tnic>
 <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
 <20131028145801.GM4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028145801.GM4314@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 at 03:58pm, Borislav Petkov wrote:
> On Mon, Oct 28, 2013 at 07:24:58PM +0800, Dave Young wrote:
> > I use linus tree, git pull Matt's efi-next tree, then apply your 12
> > patches and my patches. I applied your previous 11 patches + the last
> > update patch 12/12, but the last one does not apply, I manually shift
> > a hunk to make it apply.
> 
> Nope, still doesn't apply.
> 
> patch -p1 --dry-run -i ~/efi/dy/03-efi-enter-virtual-mode-cleanup.patch 
> checking file arch/x86/platform/efi/efi.c
> Hunk #1 succeeded at 788 (offset -1 lines).
> Hunk #2 succeeded at 821 (offset -1 lines).
> Hunk #3 FAILED at 853.
> 1 out of 3 hunks FAILED
> 
> and this time I took your patches from here: https://people.redhat.com/ruyang/kexec-efi/for-bp/kernel-patches/
> 
> What I did is:
> 
> 1. I took Linus' tree from today
> 
> 2. Merged the 'next' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git. Mind
> you, not the 'efi-next' tag!

I used the above tree origin/next branch

> 
> 3. Then I merged the 'efi' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ontop.

I used the patches from mailbox directly.
Fixed an conflict and merge them one by one.

> It gave a simple merge conflict which is trivial to resolve:
> http://paste.debian.net/62579/

Looks like I can not access above link.

> 
> Here I started applying your patches and the 3rd one still fails.
> 

It's strange to me. There must be something wrong in the steps
But sorry, it's time to sleep for me, will track this tommrrow.

Thanks
Dave
