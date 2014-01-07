Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaAGKm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:42:27 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:55696 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaAGKmZ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 7 Jan 2014 05:42:25 -0500
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
In-Reply-To: <52CB929C.6050403@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>
	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>
	 <52CB929C.6050403@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jan 2014 18:40:44 +0800
Message-ID: <1389091244.3539.6095.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2014-01-06 於 21:37 -0800，H. Peter Anvin 提到：
> On 01/06/2014 12:58 AM, joeyli wrote:
> > 於 二，2013-12-31 於 16:42 -0800，H. Peter Anvin 提到：
> >> On 12/19/2013 09:41 PM, joeyli wrote:
> >>>>
> >>>> What platform do you have that has TAD support?  I am wondering how this
> >>>> was tested.
> >>>>
> >>>
> >>> It's a testing platform that's only support get/set time functions of
> >>> ACPI TAD.
> >>>
> >>
> >> It would be really, really good to get this into Qemu (either SeaBIOS or
> >> OVMF, or ideally both) so we can have anyone test.
> >>
> >> 	-hpa
> > 
> > I will try to add to OVMF first.
> > 
> 
> For the record, I posted a patch to Qemu about a year ago to store the
> timezone in the CMOS, which might be useful for this implementation.  It
> was rejected because of no firmware support, so if you implement it for
> OVMF we can (update and) push this patch again.
> 
> 	-hpa
> 

Thanks for your patch. 

Due to accessing CMOS through ASL need enable SMM support in OVMF, I am
looking Laszlo's OVMF S3 patches:

https://www.mail-archive.com/edk2-devel@lists.sourceforge.net/msg04969.html

Honestly I am not good on this area, I need to spend more time to
understand it.


Regards
Joey Lee

