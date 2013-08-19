Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab3HSJYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:24:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3HSJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:24:46 -0400
X-AuditID: cbfee68e-b7f276d000002279-9f-5211e45c9b0b
Message-id: <5211E45B.1010109@samsung.com>
Date: Mon, 19 Aug 2013 18:24:43 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, bcousson@baylibre.com,
        tony@atomide.com, myungjoo.ham@samsung.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        rob@landley.net, george.cherian@ti.com, gregkh@linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH v2] extcon: palmas: Modified the compatible type to
 *ti,palmas-usb-vid*
References: <1376648448-27447-1-git-send-email-kishon@ti.com>
 <520EA5D6.3040409@wwwdotorg.org> <5211A7B3.4040906@ti.com>
 <5211DBB4.6090508@ti.com>
In-reply-to: <5211DBB4.6090508@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsWyRsSkWDfmiWCQwdeN0hYH79db3Jn/l9Vi
	/pFzrBanDi5ntWhevJ7N4k1vB4vFhac9bBabHl9jtVjYtoTF4vKuOWwWs5f0s1jcvsxrsfT6
	RSaL240r2CwmTF/LYnF4xQEmi3Uvp7NYvDrYxmKx/4qXg7DHmnlrGD1amnvYPL59ncTi8f5G
	K7vHgs9X2D1eT57A6PFq9UxWj/1z17B7bF5S79G3ZRWjx/Eb25k8Pm+S89g4NzSAN4rLJiU1
	J7MstUjfLoErY++zDpaCB5wVRyZ9YGtg/MXexcjJISFgInFm6i5GCFtM4sK99WxdjFwcQgJL
	GSWuv1vDClN0+8J+FojEIkaJ02d+Q1W9YpR4emsnWDuvgJbEj2Wn2EBsFgFViVMX3jOD2GxA
	8f0vboDFRQXCJFZOv8ICUS8o8WPyPTBbBKjm9M4fzCBDmQWuMUt03l0N1iAsECtxoecpI8S2
	aYwSG+ZsB9vGKaAmMe3KCbAnmAV0JPa3TmODsOUlNq95CzZJQuAGh8Tx9/fYIU4SkPg2+RDQ
	Og6ghKzEpgPMEL9JShxccYNlAqPYLCRHzUIydhaSsQsYmVcxiqYWJBcUJ6UXGekVJ+YWl+al
	6yXn525iBKaO0/+e9e1gvHnA+hBjMtDKicxSosn5wNSTVxJvaGxmZGFqYmpsZG5pRpqwkjiv
	Wot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGicXOEhZ72ievPrhGd8Pe+zqzG1Z9Cnp/
	SmjipmdHytii/r86kP6PO1BQ+fGC711Lf03N2ejQPnPa2viqi69lrvzZUSk8o+Nt6iqR526t
	R9ZFd32doGzZ0SGsueNF+7q7cR26jewnD6yqDnkkrnHmz/3+j88WscXty7gj5tHjpzGT/b55
	6QS5biWW4oxEQy3mouJEAJyuseYzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t9jAd2YJ4JBBnf7uSwO3q+3uDP/L6vF
	/CPnWC1OHVzOatG8eD2bxZveDhaLC0972Cw2Pb7GarGwbQmLxeVdc9gsZi/pZ7G4fZnXYun1
	i0wWtxtXsFlMmL6WxeLwigNMFuteTmexeHWwjcVi/xUvB2GPNfPWMHq0NPeweXz7OonF4/2N
	VnaPBZ+vsHu8njyB0ePV6pmsHvvnrmH32Lyk3qNvyypGj+M3tjN5fN4k57FxbmgAb1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0JtKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoy9zzpYCh5wVhyZ9IGtgfEXexcjJ4eE
	gInE7Qv7WSBsMYkL99azdTFycQgJLGKUOH3mN5TzilHi6a2djCBVvAJaEj+WnWIDsVkEVCVO
	XXjPDGKzAcX3v7gBFhcVCJNYOf0KC0S9oMSPyffAbBGgmtM7fzCDDGUWuMYs0Xl3NViDsECs
	xIWep4wQ26YxSmyYsx1sG6eAmsS0KyfAbmUW0JHY3zqNDcKWl9i85i3zBEaBWUiWzEJSNgtJ
	2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYnpmfQOxlUNFocYBTgYlXh4LdwEg4RY
	E8uKK3MPMUpwMCuJ8LKoAYV4UxIrq1KL8uOLSnNSiw8xJgPDYCKzlGhyPjBp5pXEGxqbmBlZ
	GpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD49b7TMryN1/uDM5V42YwW/9h
	88Itc3aV6H3bFChdVv4twsbYWG9d3mqHowwWL83Fq8V7GO4bW1k0dBxckhodnRSnsubYneVh
	LF5Os6wLuL4p7ZvVdij6zwp3bpctVdJdfB+k/i1/9bAqXkVBVojt7+RJrwxazT5f7dy51P7F
	PdtfU+5t4DUXVmIpzkg01GIuKk4EABuDXz2QAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 05:47 PM, Kishon Vijay Abraham I wrote:
> On Monday 19 August 2013 10:35 AM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Saturday 17 August 2013 03:51 AM, Stephen Warren wrote:
>>> On 08/16/2013 04:20 AM, Kishon Vijay Abraham I wrote:
>>>> The Palmas device contains only a USB VID detector, so modified the
>>>> compatible type to *ti,palmas-usb-vid*.
>>>
>>>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
>>>
>>>>  PALMAS USB COMPARATOR
>>>>  Required Properties:
>>>> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
>>>> + - compatible : Should be "ti,palmas-usb-vid".
>>>
>>> Has the old value been published in a release kernel? If so, it makes
>>
>> No. This was merged only in 3.11-rc1. So I think we should take this version?
>> Chanwoo can you take this patch?
> 
> Ah.. the old values will be part of 3.11 kernel. So should we retain the old
> values?

What is the meaning of old value? previous value related to extcon-twl.txt?

The extcon-twl.txt was included in 3.11 kernel
and extcon-palmas.txt will be inclued in 3.12 kernel through char-misc repo of GregKH.

Thanks,
Chanwoo Choi

