Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3LTWQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:16:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48527 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3LTWQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:16:08 -0500
Message-ID: <52B4C180.40904@zytor.com>
Date: Fri, 20 Dec 2013 14:15:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: joeyli <jlee@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387512357.3539.4317.camel@linux-s257.site> <52B3C5F0.1060303@zytor.com> <1775986.qxTh3ADDRn@skinner>
In-Reply-To: <1775986.qxTh3ADDRn@skinner>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 02:53 AM, Thomas Renninger wrote:
> On Thursday, December 19, 2013 08:22:08 PM H. Peter Anvin wrote:
>> On 12/19/2013 08:05 PM, joeyli wrote:
>>> Then that means the priority of PNP0B0x is higher then "CMOS RTC Not
>>> Present" flag. ACPI spec doesn't have clear definition on this.
>>
>> According to the Microsoft requirements documents, such a platform is
>> broken and shouldn't exist.
> 
> Is this a public document?
> Probably not but if, a pointer in this thread would help.
> Does Microsoft mention ACPI Time and Alarm Device interface in
> such a document already?
> 

This is the document... I can't remember who sent me the link to it:

http://goo.gl/R7S9Mk

	-hpa

