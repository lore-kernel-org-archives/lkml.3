Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaFLNIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:08:25 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:47316 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbaFLNIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:08:21 -0400
Message-ID: <5399A650.2020602@linaro.org>
Date: Thu, 12 Jun 2014 15:08:32 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 2/5] acpi, apei, ghes: Introduce ACPI_APEI_NMI to make
 NMI error notification a GHES feature.
References: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org> <1401262770-25343-3-git-send-email-tomasz.nowicki@linaro.org> <20140612103238.GB22583@rric.localhost>
In-Reply-To: <20140612103238.GB22583@rric.localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.2014 12:32, Robert Richter wrote:
> On 28.05.14 09:39:27, Tomasz Nowicki wrote:
>> +config ACPI_APEI_NMI
>> +	bool "NMI error notification support"
>> +	default y
>> +	depends on ACPI_APEI_GHES && X86
>> +	help
>> +	  Firmware first mode can use NMI notification mechanism to report errors
>> +	  to operating system. This feature is currently supported by X86
>> +	  architecture only.
>> +
>
> This selection is not necessary. I don't see why one should select
> this at all. It's either there for an arch or not. Just use ARCH_HAS_
> style and and hard select ARCH_HAS_ACPI_APEI_NMI for x86. There is no
> need for the ACPI_APEI_GHES dependency then.
>

It does make sense to me, will address your comment appropriately.

Tomasz
