Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3LTEWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:22:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39411 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3LTEWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:22:51 -0500
Message-ID: <52B3C5F0.1060303@zytor.com>
Date: Thu, 19 Dec 2013 20:22:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>
In-Reply-To: <1387512357.3539.4317.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 08:05 PM, joeyli wrote:
> 
> Then that means the priority of PNP0B0x is higher then "CMOS RTC Not
> Present" flag. ACPI spec doesn't have clear definition on this.
> 

According to the Microsoft requirements documents, such a platform is
broken and shouldn't exist.

> I look forward to Borislav's "EFI runtime mapping" to fix the physical
> address accessing issue of EFI time service on x86_64 machines. I tested
> his patches on a issue machine and it works for walk around BIOS bug.
> 
> Can we use EFI time services on x86_64 after Borislav's patches accepted
> to mainline?
> 

No.

	-hpa


