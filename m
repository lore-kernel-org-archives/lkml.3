Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3KKCPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:15:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3KKCPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:15:02 -0500
Date: Mon, 11 Nov 2013 10:13:56 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
Message-ID: <20131111021356.GC4407@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131108143118.GA22636@console-pimps.org>
 <20131109035739.GB4294@dhcp-16-126.nay.redhat.com>
 <527DC1BE.6030107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527DC1BE.6030107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 at 09:01pm, H. Peter Anvin wrote:
> On 11/08/2013 07:57 PM, Dave Young wrote:
> > 
> > Hmm, if CONFIG_DEBUG_BOOT_PARAMS is not set, then kexec-tools should
> > fail getting efi_info, so I will fix kexec-tools patch about this.
> > 
> > Also CONFIG_EFI_RUNTIME_MAP should select CONFIG_DEBUG_BOOT_PARAMS.
> > In future will try to move the boot params data out of debugfs. 
> > 
> 
> Honestly, if we need debugfs to get actual functionality, it shouldn't
> be in sploit^Wdebugfs...
> 

Huang Ying <ying.huang@intel.com> created the debugfs file for boot_params.
His first version patch tried sysfs, but sysfs is not designed for such
binary blobs so finally it go to debugfs.

Any idea for this is welcome, till now I have no better idea for such kind
of data. We should have another *fs instead of using debugfs.

Thanks
Dave
