Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3KUTZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:25:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3KUTZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:25:14 -0500
Date: Thu, 21 Nov 2013 14:24:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131121192447.GO16208@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
 <20131121190620.GA25951@srcf.ucam.org>
 <20131121191305.GK16208@redhat.com>
 <20131121191907.GA26366@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121191907.GA26366@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 07:19:07PM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 02:13:05PM -0500, Vivek Goyal wrote:
> > On Thu, Nov 21, 2013 at 07:06:20PM +0000, Matthew Garrett wrote:
> > > That would require a certain degree of massaging from userspace if we 
> > > want to be able to use the existing Authenticode signatures. Otherwise 
> > > we need to sign kernels twice.
> > 
> > I was thinking oof signing the same kernel twice. Can I sign authenticode
> > signed kernel again (using RSA signature as we do for modules) and append
> > the signature to bzImage. 
> 
> No, you'd need to do it the other way around.

Then I can't assume that RSA signatures are appened to bzImage, as we
do for modules.

Also I am assuming that authenticode signing will change something in
PE/COFF header and that would invalidate the bzImage signature.

Thanks
Vivek
