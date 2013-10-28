Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3J1LZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab3J1LZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:25:47 -0400
Date: Mon, 28 Oct 2013 19:24:58 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
 <20131028093206.GB4314@pd.tnic>
 <20131028094049.GC25527@dhcp-16-126.nay.redhat.com>
 <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
 <20131028100402.GC4314@pd.tnic>
 <20131028101011.GF25527@dhcp-16-126.nay.redhat.com>
 <20131028112045.GH4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028112045.GH4314@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 at 12:20pm, Borislav Petkov wrote:
> On Mon, Oct 28, 2013 at 06:10:11PM +0800, Dave Young wrote:
> > Sorry, I have not any public git account. Attached the patch I applied
> > with git
> 
> Still doesn't work:
> 
> $ patch -p1 --dry-run -i /tmp/02-efi-enter-virtual-mode-cleanup-1.patch.new 
> checking file arch/x86/platform/efi/efi.c
> Hunk #1 succeeded at 788 (offset -1 lines).
> Hunk #2 succeeded at 821 (offset -1 lines).
> Hunk #3 FAILED at 853.
> 1 out of 3 hunks FAILED
> 
> I'm using Matt's next branch + my efi runtime branch. What are you
> basing your stuff ontop?

I use linus tree, git pull Matt's efi-next tree, then apply your 12 patches
and my patches. I applied your previous 11 patches + the last update patch
12/12, but the last one does not apply, I manually shift a hunk to make it
apply.
