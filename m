Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3GJHGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:06:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18518 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3GJHGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:06:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Jul 2013 00:05:46 -0700
Message-ID: <51DD09ED.2070607@nvidia.com>
Date: Wed, 10 Jul 2013 12:44:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH V2 0/4] extcon: palmas: clean-up/fixes and suspend/resume
 susupport
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com> <51DD05E5.6030102@samsung.com>
In-Reply-To: <51DD05E5.6030102@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 July 2013 12:27 PM, Chanwoo Choi wrote:
> On 07/10/2013 03:15 PM, Laxman Dewangan wrote:
>> This patch series does following:
>> - Remove unused member from extcon palmas structure.
>> - Fix to support of detecting cable properly with multiple insert/removal.
>> - Add support for suspend/resume functionlaity and wakup from suspend.
>> - Option to select/de-select the ID or VBUS detection.
>>
>> Changes from V1:
>> - Correct the display message.
>> - Add ack from Graeme
>>
>> Laxman Dewangan (4):
>>    extcon: palmas: remove unused member from palams_usb structure
>>    extcon: palmas: enable ID_GND and ID_FLOAT detection always
>>    extcon: palams: add support for suspend/resume
>>    extcon: palmas: Option to disable ID/VBUS detection based on platform
>>
> Patch 1/2/3 is only applied on extcon-linus branch.
>
> I replied about patch4.
>
Thank you very much for taking care.
Working on Patch4.

Thanks,
Laxman
