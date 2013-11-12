Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3KLIUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:20:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3KLIUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:20:32 -0500
Date: Tue, 12 Nov 2013 16:19:37 +0800
From: Dave Young <dyoung@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 4/7 v2] export more efi table variable to sysfs
Message-ID: <20131112081937.GE6999@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082717.561020034@dhcp-16-126.nay.redhat.com>
 <20131112004014.GA15377@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112004014.GA15377@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13 at 04:40pm, Greg KH wrote:
> On Tue, Nov 05, 2013 at 04:20:11PM +0800, dyoung@redhat.com wrote:
> > Export fw_vendor, runtime and config tables physical
> > addresses to /sys/firmware/efi/systab becaue kexec
> > kernel will need them.
> 
> sysfs files are one-value-per-file.
> 
> Please don't abuse this and add more values to this single file, in
> fact, it should be broken up into individual sysfs files as it is,
> because this isn't ok now.
> 
> Sorry, you don't get to abuse this anymore :(

Ok, I know this, just creating this without thinking about carefully.
Will redo the patch, thanks for catching.

Thanks
Dave
