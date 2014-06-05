Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaFERzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:55:50 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:64866 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaFERzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:55:48 -0400
X-AuditID: cbfec37a-b7f206d000005572-9e-5390af23b956
Message-id: <5390AF20.4090300@samsung.com>
Date: Thu, 05 Jun 2014 11:55:44 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 000/103] 3.10.42-stable review
References: <20140604232546.704156131@linuxfoundation.org>
In-reply-to: <20140604232546.704156131@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP13l9ROCDQ6v5LaYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGbdXeBScZauYNe0YUwPjXNYuRk4OCQETibtLO5ghbDGJC/fWs3Ux
	cnEICSxjlFjSv4QRwullkpi6YycThLOBUWJn/1FGkBZeAS2JNRMgRrEIqEr09O0EG8UmoC7x
	+fUOdhBbSEBOomnJaqA4B4eoQITE4wtCEK2CEj8m32MBsUUEgiXWfl0ItoxZYBWjxPXLy9lA
	EsIC5hJN9z5AzbGSOLP/OROIzSlgLTH/zHSwvcwCZhKPWtYxQ9jyEpvXvGWGqFeW+HP5FBPE
	awoSj662sk9gFJmFZPcsJO2zkLQvYGRexShWWpxcUJyUnlphqFecmFtcmpeul5yfu4kREklV
	OxjvfLU5xCjAwajEwxvQPyFYiDWxrLgy9xCjBAezkggvzwqgEG9KYmVValF+fFFpTmrxIUYm
	Dk6pBkbG73WtF71Eb72u3mXqWPJnjn7U7eyPWVllKpsnh50ReXtOwOB4sWVa9BrlqYtCzFZc
	vX7xodLpKzObbq2V/+jmcWPTyqrt/0sKd3VuiG31uFXkebj3ierFtIZitonLQidKiNTsCg19
	/qlKaP0tk1NzZO0td3I0icaa7g4p7L1ZLF3Wb7hsynklluKMREMt5qLiRACIAmiNggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:24 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.42 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Jun  6 23:24:52 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.42-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system with no dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
