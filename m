Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3KLIbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:31:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3KLIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:31:48 -0500
Date: Tue, 12 Nov 2013 00:31:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 4/7 v2] export more efi table variable to sysfs
Message-ID: <20131112083110.GA7892@kroah.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082717.561020034@dhcp-16-126.nay.redhat.com>
 <20131112004014.GA15377@kroah.com>
 <20131112081937.GE6999@dhcp-16-126.nay.redhat.com>
 <20131112082401.GA13899@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112082401.GA13899@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 04:24:01PM +0800, Dave Young wrote:
> On 11/12/13 at 04:19pm, Dave Young wrote:
> > On 11/11/13 at 04:40pm, Greg KH wrote:
> > > On Tue, Nov 05, 2013 at 04:20:11PM +0800, dyoung@redhat.com wrote:
> > > > Export fw_vendor, runtime and config tables physical
> > > > addresses to /sys/firmware/efi/systab becaue kexec
> > > > kernel will need them.
> > > 
> > > sysfs files are one-value-per-file.
> > > 
> > > Please don't abuse this and add more values to this single file, in
> > > fact, it should be broken up into individual sysfs files as it is,
> > > because this isn't ok now.
> > > 
> > > Sorry, you don't get to abuse this anymore :(
> > 
> > Ok, I know this, just creating this without thinking about carefully.
> > Will redo the patch, thanks for catching.
> 
> I would like to add new files for the values used in this patchset.
> And will split the original systab later in another patchset.

That's fine with me, thanks.

greg k-h
