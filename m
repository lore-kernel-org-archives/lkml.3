Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3LTVPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:15:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48042 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3LTVPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:15:01 -0500
Message-ID: <52B4B331.9000608@zytor.com>
Date: Fri, 20 Dec 2013 13:14:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "jlee@suse.com" <jlee@suse.com>, "bp@suse.de" <bp@suse.de>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>	 <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>	 <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>	 <1387558713.17961.4.camel@x230>	 <a049daea-a713-4d06-b35f-61f3bec06ba9@email.android.com> <1387571531.17961.6.camel@x230>
In-Reply-To: <1387571531.17961.6.camel@x230>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 12:32 PM, Matthew Garrett wrote:
> On Fri, 2013-12-20 at 12:29 -0800, H. Peter Anvin wrote:
>> Yes, but the TZ isn't all that critical, either.  It certainly doesn't matter at all for a pure Linux system.
> 
> No, but it does matter for a great number of deployed Linux systems.
> Dealing with the timezone over DST changes has been a perpetual problem,
> and if we can make that work then life will be significantly better.
> 

And as I pointed out, it can matter a lot for VMs, since the provider
doesn't want to provision the VMs differently for different types of guests.

	-hpa

