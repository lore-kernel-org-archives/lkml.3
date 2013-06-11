Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3FKQ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:56:59 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2074 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab3FKQ46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:56:58 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51B756CD.1070500@broadcom.com>
Date: Tue, 11 Jun 2013 09:56:45 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Olof Johansson" <olof@lixom.net>
cc: "Matt Porter" <matt.porter@linaro.org>, "Arnd Bergmann" <arnd@arndb.de>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linaro Patches" <patches@linaro.org>
Subject: Re: [PATCH 0/2] ARM dts: bcm281xx: use preprocessor for device
 trees
References: <1370497295-12682-1-git-send-email-matt.porter@linaro.org>
 <20130611070344.GF6688@quad.lixom.net>
In-Reply-To: <20130611070344.GF6688@quad.lixom.net>
X-WSS-ID: 7DA98A7831W34797859-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-11 12:03 AM, Olof Johansson wrote:
> On Thu, Jun 06, 2013 at 01:41:33AM -0400, Matt Porter wrote:
>> This series follows the same approach as taken on Tegra and
>> OMAP DT files to use the C preprocessor in order to improve
>> readability. Since bcm281xx does not yet have gpio and pinctrl
>> support, this series just enables the C preprocessor and removes
>> the magic constants from existing irq properties. Any new
>> additions can come in using human readable definitions.
>>
>> The resulting dtb was diff-tested to validate it versus the non
>> preprocessed dts version.
>>
>> Matt Porter (2):
>>    ARM: dts: bcm281xx: use #include for device tree files
>>    ARM: dts: bcm281xx: use existing defines for irqs
> Acked-by: Olof Johansson <olof@lixom.net>
Acked-by: Christian Daudt <csd@broadcom.com>
>
> Not sure what else you'll have for 3.11 devicetree-wise, Christian -- your
> choice if you want to send a pull request or ack these and we'll apply them
> directly.
>
I can add them to my tree. I already have a pending dt commit to push.

  thanks,
    csd




