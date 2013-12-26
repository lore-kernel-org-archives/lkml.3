Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3LZCMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 21:12:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3LZCMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 21:12:25 -0500
Date: Thu, 26 Dec 2013 10:12:38 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: matt@console-pimps.org, greg@kroah.com, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: split efi systab in sysfs
Message-ID: <20131226021238.GB3750@dhcp-16-126.nay.redhat.com>
References: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
 <52BB8C8F.1020606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BB8C8F.1020606@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/13 at 05:55pm, H. Peter Anvin wrote:
> On 12/25/2013 05:53 PM, Dave Young wrote:
> > Hi, Matt and Peter
> > 
> > Currently /sys/firmware/efi/systab contains multi-lines for efi systab
> > entries. As previous discussion with Greg, this is not a good in sysfs.
> > I wonder if there's other users for this file except kexec-tools.
> > 
> > If kexec-tools is the only user, maybe I can split it as several files.
> > In kexec-tools just use /sys/firmware/efi/"$entry_name" and if $entry_name
> > does not exist then switch to old systab file. 
> > 
> 
> Yes, the sysfs standard is "one entry per datum".  I have no idea about
> who the user(s) might be, though.

Even the only known user kexec-tools, for new kernel + old kexec-tools we
have no way to support, maybe this systab should be kept forever...
