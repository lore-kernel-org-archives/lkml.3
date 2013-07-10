Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3GJG5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:57:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22638 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3GJG5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:57:43 -0400
X-AuditID: cbfee691-b7fef6d000002d62-3d-51dd05e58ec7
Message-id: <51DD05E5.6030102@samsung.com>
Date: Wed, 10 Jul 2013 15:57:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: myungjoo.ham@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH V2 0/4] extcon: palmas: clean-up/fixes and suspend/resume
 susupport
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
In-reply-to: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkUPcp691Ag/kntS0OzH7IatG/xcXi
	wtMeNoul+1azWCxsW8JicXnXHDaL240r2CzWvZzO4sDh8Wr1TFaP8zMWMnr0Nr9j8+jbsorR
	Y+qUv4wex29sZ/L4vEkugD2KyyYlNSezLLVI3y6BK2PywgksBYfZKvZ/nMjSwDiLtYuRk0NC
	wERi4paLTBC2mMSFe+vZuhi5OIQEljJK3HrewgRTtONGFztEYjqjxM7/96CcV4wS7Tu3g1Xx
	CmhJHGv4DDSWg4NFQFXi+mlfkDAbUHj/ixtsILaoQJjEyulXWCDKBSV+TL4HZosA1Xw78I8Z
	ZCazwCZGiVXTZjGDJIQFIiUm/5gHdqqQgIvEgU8HGEFsTgFXiUWb3rCD2MwCOhL7W6exQdjy
	EpvXvAUbJCHwkl3i5asPYEUsAgIS3yYfYgE5TkJAVmLTAWaIzyQlDq64wTKBUWwWkptmIRk7
	C8nYBYzMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECo/L0v2cTdzDeP2B9iDEZaOVEZinR
	5HxgVOeVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gbEzU+WW0YZ5Lsez59Z0HuIQCP5UwfT8Vl5+ueOrXWwr89fKz3sy19QkOefP9Sw/941Hsne6
	urbde205+evnKSecphps4042sU0O3NwpGmfn2dR3KOtRFRvnSUX+SeqB82rF73htXmnXGXso
	9k8IC5fR5tCqprqvd48JzWD94P1P7IBh7Nfna5RYijMSDbWYi4oTAfFgq6bgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd2nrHcDDWYuVbE4MPshq0X/FheL
	C0972CyW7lvNYrGwbQmLxeVdc9gsbjeuYLNY93I6iwOHx6vVM1k9zs9YyOjR2/yOzaNvyypG
	j6lT/jJ6HL+xncnj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	kxdOYCk4zFax/+NElgbGWaxdjJwcEgImEjtudLFD2GISF+6tZ+ti5OIQEpjOKLHz/z12COcV
	o0T7zu1MIFW8AloSxxo+A3VzcLAIqEpcP+0LEmYDCu9/cYMNxBYVCJNYOf0KC0S5oMSPyffA
	bBGgmm8H/jGDzGQW2MQosWraLGaQhLBApMTkH/PALhIScJE48OkAI4jNKeAqsWjTG7DrmAV0
	JPa3TmODsOUlNq95yzyBUWAWkh2zkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZwzD+T3sG4qsHiEKMAB6MSD+8BhTuBQqyJZcWVuYcYJTiYlUR4/10CCvGmJFZWpRblxxeV
	5qQWH2JMBobARGYp0eR8YDrKK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFq
	EcwWJg5OqQZGg7p34ke9f95xcnjeu4F5zs7bz8okrvocjRHc+W0J846H3zSErGe+XMq8XHvq
	fLOsZ33/WNMDrhgsfbjalPfEjXPBvnq2R2/ltkfU3r6vzKae0bbw8I8Apfvf/ZStCvY9Y0xL
	bdpi8P/r8c1RL02j+hLPpLS7fn1xcEZd6Y0pPAG5r0qPhHW0KLEUZyQaajEXFScCAAwV6Sk9	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 03:15 PM, Laxman Dewangan wrote:
> This patch series does following:
> - Remove unused member from extcon palmas structure.
> - Fix to support of detecting cable properly with multiple insert/removal.
> - Add support for suspend/resume functionlaity and wakup from suspend.
> - Option to select/de-select the ID or VBUS detection.
> 
> Changes from V1:
> - Correct the display message.
> - Add ack from Graeme
> 
> Laxman Dewangan (4):
>   extcon: palmas: remove unused member from palams_usb structure
>   extcon: palmas: enable ID_GND and ID_FLOAT detection always
>   extcon: palams: add support for suspend/resume
>   extcon: palmas: Option to disable ID/VBUS detection based on platform
> 

Patch 1/2/3 is only applied on extcon-linus branch.

I replied about patch4.

Thanks,
Chanwoo Choi

