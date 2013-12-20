Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3LTKiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:38:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47352 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3LTKiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:38:05 -0500
Date: Fri, 20 Dec 2013 11:37:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
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
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Message-ID: <20131220103755.GA14784@pd.tnic>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
 <1387439515-8926-7-git-send-email-jlee@suse.com>
 <20131219140918.GF3145@console-pimps.org>
 <1387513491.3539.4345.camel@linux-s257.site>
 <52B3C7F8.3040901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52B3C7F8.3040901@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
> On 12/19/2013 08:24 PM, joeyli wrote:
> > I agreed, but userspace application should not be too often to access
> > RTC. Maybe only when system boot and set timezone.
>
> This is, quite frankly, an idiotic argument.

TBH, I've been struggling with the question too - and it might even be a
stupid question - but what is that absolute need to be able to get the
TZ in userspace? Why should I care?

Can we get some use cases for stupid people like me please?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
