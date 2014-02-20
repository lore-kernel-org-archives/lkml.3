Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaBTBUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:20:21 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:38974 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaBTBUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:20:19 -0500
X-AuditID: cbfec37d-b7ff46d000005528-51-5305584fab20
Message-id: <5305584D.9030106@samsung.com>
Date: Wed, 19 Feb 2014 18:20:13 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
References: <20140218224433.337299968@linuxfoundation.org>
 <53054956.4010602@samsung.com> <20140220003639.GF2669@sirena.org.uk>
In-reply-to: <20140220003639.GF2669@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX13/CNZgg/5dOhZz1q9hs5j68Amb
	RfPi9WwWl3fNYbP4+tPBYsHGR4wWj/resjuwe+ycdZfdY9OqTjaPEzN+s3jsn7uG3ePzJrkA
	1igum5TUnMyy1CJ9uwSujDXdz9kLdnNUXH0wmaWB8R5bFyMnh4SAicTqE3OYIWwxiQv31gPF
	uTiEBJYxSnS9OAPl9DJJHO69ywThbGCUOL/4BwtIC6+AlsShzd2sIDaLgKrE4Q+NYGPZBNQl
	Pr/ewQ5iCwnISTQtWQ22QlQgQuLV2YlQvYISPybfA7NFBJQlrn7fywKygFngGqPE5qMtYA3C
	QPfd+fmIBWJzI6NEz7dlYNs4BYwknp08DdbNLGAtsXLSNkYIW15i85q3zBCblSX+XD7FBPGc
	gsSNhctYJzCKzEKyfBaS9llI2hcwMq9iFCstTi4oTkpPrTDRK07MLS7NS9dLzs/dxAiJptod
	jPe/2hxiFOBgVOLhjbjOEizEmlhWXJl7iFGCg1lJhDeajTVYiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA2NxxTMxD74q/6ilwQfO+51kZ/tnb+du396wfXH7sUafrNXP3knPCNkUwjDvhFJkysyz
	pvVSWv7llj21HXuMV52MiVyoMGdPxbnXzAqP9Qr/rJ/k6HC4ZfMMX+dFzhxd6nMkzke1nZ/v
	Xi/rkPjweHr287OFF4OfcP1uedVVs/bwtH+MVdsariixFGckGmoxFxUnAgBRvb6dhAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 05:36 PM, Mark Brown wrote:
> On Wed, Feb 19, 2014 at 05:16:22PM -0700, Shuah Khan wrote:
>
>> On Intel systems, there are no dmesg regressions: emerg, crit,
>> alert, err are clean. No regressions in warn.
>
>> On AMD systems, the following new error messages - suspect is to
>> drivers/regulator/core.c - patch
>
>> 3.13.4 - amd:
>>> sdhci-pci 0000:02:00.1: dummy supplies not allowed
>>> sdhci-pci 0000:02:00.1: dummy supplies not allowed
>> drivers/regulator/core.c - patch
>
> This is nothing to do with AMD or Intel, it's to do with if your system
> has a sdhci-pci device in it.  This shouldn't result in a change in
> actual behaviour, it's just a warning caused by the fact that we now do
> provide dummies for other devices.
>

Right. I think this message should be a warning instead of an error. 
Error is too alarming, unless there is a good reason for it to be an error.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
