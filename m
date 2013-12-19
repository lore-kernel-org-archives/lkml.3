Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3LSPXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:23:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60846 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3LSPXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:23:30 -0500
Message-ID: <52B30F43.1060306@zytor.com>
Date: Thu, 19 Dec 2013 07:22:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
References: <1387439515-8926-1-git-send-email-jlee@suse.com> <1387439515-8926-5-git-send-email-jlee@suse.com>
In-Reply-To: <1387439515-8926-5-git-send-email-jlee@suse.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 11:51 PM, Lee, Chun-Yi wrote:
> This patch add the driver of Time and Alarm Device in ACPI 5.0.
> Currently it only implemented get/set time functions and grab
> the capabilities of device when driver initial.
> 
> This driver also register rtc-acpitad platform device for RTC ACPITAD
> stub driver using.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

What platform do you have that has TAD support?  I am wondering how this
was tested.

	-hpa


