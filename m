Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3LTVLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:11:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3LTVLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:11:05 -0500
Message-ID: <52B4B242.5010002@zytor.com>
Date: Fri, 20 Dec 2013 13:10:26 -0800
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
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>	 <52B3C5F0.1060303@zytor.com> <1387517916.3539.4446.camel@linux-s257.site>
In-Reply-To: <1387517916.3539.4446.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:38 PM, joeyli wrote:
> 
> If don't use EFI time, then the first priority is using ACPI TAD if it
> present. Due to ACPI TAD is a generic acpi device that's need OS parsing
> DSDT table before set system time.
> 
> Either move DSDT parser from subsystem initial stage to start_kernel or
> move timekeeping initial to after DSDT be parsed. Which one you think is
> more possible and risk less? Then I will try that way.
> 

I discussed the DSDT/SSDT parsing issue with Rafael and he claims it
would require a lot of restructuring.  Unfortunately ACPI is at this
point done rather late, as I understand.  All of this is a big problem.

	-hpa

