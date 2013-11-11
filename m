Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3KKCsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:48:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3KKCsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:48:11 -0500
Date: Mon, 11 Nov 2013 10:47:01 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, Greg KH <greg@kroah.com>
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
Message-ID: <20131111024701.GD4407@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131108143118.GA22636@console-pimps.org>
 <20131109035739.GB4294@dhcp-16-126.nay.redhat.com>
 <527DC1BE.6030107@zytor.com>
 <20131111021356.GC4407@dhcp-16-126.nay.redhat.com>
 <52803F15.3080204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52803F15.3080204@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 at 06:21pm, H. Peter Anvin wrote:
> On 11/10/2013 06:13 PM, Dave Young wrote:
> > 
> > Huang Ying <ying.huang@intel.com> created the debugfs file for boot_params.
> > His first version patch tried sysfs, but sysfs is not designed for such
> > binary blobs so finally it go to debugfs.
> > 
> 
> That is a misunderstanding.  Binary blobs can exist in sysfs as long as
> the blob is something that is inherently a blob.  This is admittedly a
> corner case, but it is without any doubt a protocol-defined binary
> structure.

You are right. Greg objected that the whole structure being exported directly.

> 
> The reason it was put in debugfs is that there was no non-debug user for
> it at the time.

Ok, I did not know this background.

> 
> > Any idea for this is welcome, till now I have no better idea for such kind
> > of data. We should have another *fs instead of using debugfs.
> 
> The problem with debugfs is that things go into debugfs with largely no
> auditing.  As a result, mounting debugfs is very likely to mean that
> your system is exploitable one way or another.

Hmm, agree. Thanks for explaining about it.

Thanks
Dave
