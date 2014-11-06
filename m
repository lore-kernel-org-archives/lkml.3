Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaKFH0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:26:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62980 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFH0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:26:52 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-28-545b22b94f5c
Message-id: <545B22B6.9050607@samsung.com>
Date: Thu, 06 Nov 2014 08:26:46 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/panel: ld9040: Update calls to gpiod_get*()
References: <1414052177-19978-1-git-send-email-acourbot@nvidia.com>
 <5448CE4A.6010207@samsung.com>
 <CAAVeFu+wiczN3zP-phsCy=-59pxJQcoyzeQpen4PNbywjymtFg@mail.gmail.com>
In-reply-to: <CAAVeFu+wiczN3zP-phsCy=-59pxJQcoyzeQpen4PNbywjymtFg@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xK7o7laJDDK7uVbD4/vAUq8WVr+/Z
	LM69esRicXnXHDaLn7vmsTiweuycdZfd4373cSaP3uZ3bB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZTxtX8RUsJG9YvWVG8wNjG1sXYwcHBICJhKbduZ1MXICmWISF+6tBwpzcQgJLGWUmPnyFBOE
	84lR4tPeQ4wgVbwCWhJXV7Wzg9gsAqoSDS96weJsApoSfzffZAOxRQUiJK6smQNVLyjxY/I9
	FpBlIgIaEo/WiYDMZBa4zShxo28/M0hcWMBF4vSnSohdq4F23XwKNodTIFhiwYFzYDXMAuoS
	U6bkgoSZBeQlNq95yzyBUWAWkg2zEKpmIalawMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93
	EyMkhL/uYFx6zOoQowAHoxIPbwR7dIgQa2JZcWXuIUYJDmYlEd5eaaAQb0piZVVqUX58UWlO
	avEhRiYOTqkGxsbypUkP125atVpxRfVjxZizams2M4pEmp4s/5IZsstpcfmFl/+vflafrznP
	Xbrswctelb82Se5JcYbr30reYd0UMuf5i9R98zyvr7zVt7aoxa17D7cnK8NT9bDL280+Okqo
	buN62xvSGFF3v2OzTOv3+1kyG2t/BoabRk76u7Kfi+dC22uet0osxRmJhlrMRcWJAFLsq7g/	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 04:32 AM, Alexandre Courbot wrote:
> On Thu, Oct 23, 2014 at 6:45 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:
>> On 10/23/2014 10:16 AM, Alexandre Courbot wrote:
>>> Add the new flags argument to calls of (devm_)gpiod_get*() and
>>> remove any direction setting code afterwards.
>>>
>>> Currently both forms (with or without the flags argument)
>>> are valid thanks to transitional macros in
>>> <linux/gpio/consumer.h>. These macros will be removed once
>>> all consumers are updated and the flags argument will become
>>> compulsary.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> It needs patch "gpio: Fix gpio direction flags not getting set" to work
>> correctly. It is not yet present in drm-next. Beside this:
>>
>> Acked-by: Andrzej Hajda <a.hajda@samsung.com>
> The required patch is now merged, can we go on with this patch?
>
Yes, for both panels. Thanks.

Regards
Andrzej

