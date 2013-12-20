Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3LTQtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:49:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45755 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab3LTQtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:49:33 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131220103755.GA14784@pd.tnic>
References: <1387439515-8926-1-git-send-email-jlee@suse.com> <1387439515-8926-7-git-send-email-jlee@suse.com> <20131219140918.GF3145@console-pimps.org> <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com> <20131220103755.GA14784@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI enabled
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 20 Dec 2013 08:48:04 -0800
To: Borislav Petkov <bp@alien8.de>
CC: joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Message-ID: <bdf7e604-0aad-4064-ba4c-89f8bb7d82cf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only real use case for the RTC TZ is compatibility with other operating systems that don't keep the time in UTC, at least as far as I can tell.  However, that is a fairly big one, especially in VM deployments.

Borislav Petkov <bp@alien8.de> wrote:
>On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
>> On 12/19/2013 08:24 PM, joeyli wrote:
>> > I agreed, but userspace application should not be too often to
>access
>> > RTC. Maybe only when system boot and set timezone.
>>
>> This is, quite frankly, an idiotic argument.
>
>TBH, I've been struggling with the question too - and it might even be
>a
>stupid question - but what is that absolute need to be able to get the
>TZ in userspace? Why should I care?
>
>Can we get some use cases for stupid people like me please?
>
>Thanks.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
