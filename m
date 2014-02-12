Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaBLSzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:55:54 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:54656 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaBLSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:55:52 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-02-52fbc3b7de5f
Message-id: <52FBC3B4.4090908@samsung.com>
Date: Wed, 12 Feb 2014 11:55:48 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/30] 3.4.80-stable review
References: <20140211184647.149512538@linuxfoundation.org>
 <20140212041922.GA26490@roeck-us.net>
In-reply-to: <20140212041922.GA26490@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX93th38HGXz/IGMxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfGjgdt7AXNXBUzLt5maWBs4uhi5OSQEDCR+LrxCyOELSZx4d56ti5GLg4hgWWMEhNa
	X0M5vUwS3/etY4FwNjBKvOw8xA7SwiugJXF76jM2EJtFQFXi/MVuMJtNQF3i8+sdYDVCAnIS
	TUtWM4PYogIREq/OTmSB6BWU+DH5HpgtImAs0X92Flg9s8AxRomFzSYgtjBQfOr0+VBzkiRa
	Ny8Em88pYCRxcccyJoh6a4mVk7YxQtjyEpvXvGWGqFeW+HP5FBPEawoS6y8cZp3AKDILyepZ
	SNpnIWlfwMi8ilGstDi5oDgpPbXCWK84Mbe4NC9dLzk/dxMjJGpqdjDe+2pziFGAg1GJh9di
	2e8gIdbEsuLK3EOMEhzMSiK8Rs1AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyW959FSvm/2W8U
	4H9myetbnel+SzxfZaiHRyVs6quY6meUFqrhVt0VVBh4XSrQ7+/S/9mfAu4c/8Y9q+3xB+Xa
	Mg77k5WP2GXr1F+Ef9LUXn2R7f5OQd6kSh/O1Y2+GZVqByXSI5aq+utLSrtXBi37f+j+s0J9
	A/+MxAixd54G+mGfLqxJU2Ipzkg01GIuKk4EADnOhYp4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 09:19 PM, Guenter Roeck wrote:
> On Tue, Feb 11, 2014 at 11:06:00AM -0800, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.4.80 release.
>> There are 30 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Feb 13 18:46:37 UTC 2014.
>> Anything received after that time might be too late.
>>
> Build results:
> 	total: 119 pass: 97 skipped: 18 fail: 4
>
> qemu tests all passed.
>
> Results are as expected.
>
> Details are available at http://server.roeck-us.net:8010/builders.
>
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Worked fine on all my test systems. Compile tests and boot tests passed. 
No dmesg regressions: emerg, crit, alert, err are clean. No regressions 
in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
