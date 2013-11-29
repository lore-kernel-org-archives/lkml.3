Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3K2JfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:35:18 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8078 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3K2JfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:35:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 29 Nov 2013 01:28:42 -0800
Message-ID: <52985FC8.70008@nvidia.com>
Date: Fri, 29 Nov 2013 18:35:04 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: use platform GPIO mappings as fallback
References: <1385202890-9511-1-git-send-email-acourbot@nvidia.com> <CACRpkdbun289Y1fu-=sB77ESg6E15hRCcd+NYmwk57MoxkoTMQ@mail.gmail.com>
In-Reply-To: <CACRpkdbun289Y1fu-=sB77ESg6E15hRCcd+NYmwk57MoxkoTMQ@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 06:29 PM, Linus Walleij wrote:
> On Sat, Nov 23, 2013 at 11:34 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> For platforms that use device tree or ACPI as the standard way to look
>> GPIOs up, allow the platform-defined GPIO mappings to be used as a
>> fallback. This may be useful for platforms that need extra GPIOs mappings
>> not defined by the firmware.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Applied for fixes. I was considering applying it for the next
> kernel but it depends on the former patches and we should
> expect a bit of extra fuzz now with the new API.

Thanks - I'd rather have all the problems coming in a row than 
incrementally as we introduce potentially incompatible changes.

Alex.

