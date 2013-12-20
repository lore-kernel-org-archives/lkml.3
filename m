Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3LTEHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:07:24 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:42330 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LTEHW (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 19 Dec 2013 23:07:22 -0500
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
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
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
In-Reply-To: <52B309EB.90300@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <52B309EB.90300@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Dec 2013 12:05:57 +0800
Message-ID: <1387512357.3539.4317.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-12-19 於 06:59 -0800，H. Peter Anvin 提到：
> On 12/18/2013 11:43 PM, Lee, Chun-Yi wrote:
> > This patchset add the timezone support of ACPI TAD and EFI TIME, it
> > also add codes for adjusting system time base on the timezone value
> > from EFI TIME services when system boot.
> 
> EFI time is something we used to support and ripped out, because it
> doesn't work well, *at all*.
> 
> I am hyper-skeptical to reintroducing them, and *definitely* will veto
> reintroducing them on a system which has PNP0B0x devices present.
> 
> 	-hpa
> 

Then that means the priority of PNP0B0x is higher then "CMOS RTC Not
Present" flag. ACPI spec doesn't have clear definition on this.

I look forward to Borislav's "EFI runtime mapping" to fix the physical
address accessing issue of EFI time service on x86_64 machines. I tested
his patches on a issue machine and it works for walk around BIOS bug.

Can we use EFI time services on x86_64 after Borislav's patches accepted
to mainline?


Thanks a lot!
Joey Lee

