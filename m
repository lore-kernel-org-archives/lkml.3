Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbaGRJXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:23:32 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60421 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760649AbaGRJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:23:30 -0400
Message-ID: <53C8E753.4070509@linaro.org>
Date: Fri, 18 Jul 2014 17:22:27 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 1/3] ACPI: ARM64 does not have a BIOS add config for
 BIOS table scan.
References: <1404898746-6685-1-git-send-email-hanjun.guo@linaro.org> <1404898746-6685-2-git-send-email-hanjun.guo@linaro.org> <53C70CCC.2080109@zytor.com> <3908561D78D1C84285E8C5FCA982C28F3285FB3C@ORSMSX114.amr.corp.intel.com> <53C70F78.40206@zytor.com> <53C7406E.40902@linaro.org> <3908561D78D1C84285E8C5FCA982C28F32866139@ORSMSX113.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32866139@ORSMSX113.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-7-18 0:58, Luck, Tony wrote:
>> Tony, if it is ok with you, I will modify the patch and will not select
>> ACPI_LEGACY_TABLES_LOOKUP on IA64, I'm waiting for your final confirmation.
> 
> Confirmed.  Thanks Peter for catching this.

Great, I will update the patch and send out soon.

Thanks
Hanjun

