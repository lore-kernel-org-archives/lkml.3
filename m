Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3LTQ6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:58:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab3LTQ6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:58:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1387552565.17961.3.camel@x230>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site> <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 20 Dec 2013 08:57:03 -0800
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Message-ID: <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But we prefer the TAD for that.  The case where the EFI runtime is the only source of that info is problematic as they are known to not work at runtime.  We could collect it at boot and then never change it, although you end up in definitional issues between EFI and the hw RTC.

Matthew Garrett <matthew.garrett@nebula.com> wrote:
>On Thu, 2013-12-19 at 20:22 -0800, H. Peter Anvin wrote:
>> On 12/19/2013 08:05 PM, joeyli wrote:
>> > Can we use EFI time services on x86_64 after Borislav's patches
>accepted
>> > to mainline?
>> > 
>> 
>> No.
>
>We will want to use them to (at minimum) obtain the clock timezone.
>Using them for general RTC access is less attractive.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
