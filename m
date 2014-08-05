Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaHEXHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:07:53 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:30685 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaHEXHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:07:51 -0400
X-AuditID: cbfec37a-b7f216d000000635-17-53e163c5117b
Message-id: <53E163C2.4060009@samsung.com>
Date: Tue, 05 Aug 2014 17:07:46 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.14 00/39] 3.14.16-stable review
References: <20140805181336.030349158@linuxfoundation.org>
In-reply-to: <20140805181336.030349158@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP92jyQ+DDWadMrWYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGV+e7mQseMxWcfj5CtYGxo2sXYycHBICJhJnDvxhgbDFJC7cW8/W
	xcjFISSwjFFib8N2Rginl0li68sdUM4GRomWU3sYQVp4BbQkOlrmgtksAqoSj9f9Zgax2QTU
	JT6/3sEOYgsJyEk0LVkNFhcViJA40PeMFaJXUOLH5Htgq0UEgiXWfl0ItoBZYBWjxPXLy9lA
	EsICphKnvu0FauAAGmQlsexBOkiYU8BaYs35U2AzmYHslZO2MULY8hKb17xlhtirLPHn8ikm
	iNcUJB5dbWWfwCgyC8nqWUjaZyFpX8DIvIpRrLQ4uaA4KT21wlCvODG3uDQvXS85P3cTIySW
	qnYw3vlqc4hRgINRiYc3w/RhsBBrYllxZe4hRgkOZiUR3i3xQCHelMTKqtSi/Pii0pzU4kOM
	TBycUg2MsTLTNMqX311drxS07+P1mhmzJ0rmHkv+7qlgsHdXBl/xYevUms9Tini3bOMUOng8
	KGm+znalJd2tzvof8n48U13kK+L4+HrsifsnIxVO3ZSZe75LPCi8dFa9utay84sFnz9X4dxf
	esD1kEOmDcvTnQ1bOKT18zb0TvI4fsjEb9uEM5LO6zKmKrEUZyQaajEXFScCAIVUOYmDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.16 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug  7 18:13:27 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.16-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No dmesg regressions
compared to previous 3.14.15

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
