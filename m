Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3LSPAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:00:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60578 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3LSPAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:00:39 -0500
Message-ID: <52B309EB.90300@zytor.com>
Date: Thu, 19 Dec 2013 06:59:55 -0800
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
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
In-Reply-To: <1387439053-8711-1-git-send-email-jlee@suse.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 11:43 PM, Lee, Chun-Yi wrote:
> This patchset add the timezone support of ACPI TAD and EFI TIME, it
> also add codes for adjusting system time base on the timezone value
> from EFI TIME services when system boot.

EFI time is something we used to support and ripped out, because it
doesn't work well, *at all*.

I am hyper-skeptical to reintroducing them, and *definitely* will veto
reintroducing them on a system which has PNP0B0x devices present.

	-hpa

