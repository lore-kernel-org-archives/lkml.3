Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaGHTbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:31:55 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:23238 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaGHTbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:31:53 -0400
X-AuditID: cbfec37a-b7f206d000005572-3f-53bc4727c82c
Message-id: <53BC4725.4010801@samsung.com>
Date: Tue, 08 Jul 2014 13:31:49 -0600
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
Subject: Re: [PATCH 3.10 00/53] 3.10.48-stable review
References: <20140707235829.281783607@linuxfoundation.org>
In-reply-to: <20140707235829.281783607@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX10N9z3BBsv1LeasX8Nm0bx4PZvF
	5V1z2CyeLDzDZDH11AQWiwUbHzFaPOp7y+7A7rFz1l12jxMzfrN47J+7Bsj93sDu8XmTXABr
	FJdNSmpOZllqkb5dAlfGsc4HTAXH2Cou/JzD0sA4k7WLkZNDQsBE4uiB80wQtpjEhXvr2boY
	uTiEBJYxSqx7+pUVwullklhwfS0zhLONUWLvpnmMIC28AloSH26vYgexWQRUJU79bWMGsdkE
	1CU+v94BFhcSkJNoWrIaLC4qECFxoO8ZK0SvoMSPyfdYQGwRgWCJtV8XMoIsYBZYxShx/fJy
	NpCEsICpxK+Pc5khBllJ3Lh3CqyBU8BaYufif2A1zAJmEo9a1jFD2PISm9e8hapXlvhz+RTU
	b8oSExtvs0xgFJmFZPcsJO2zkLQvYGRexShWWpxcUJyUnlphqFecmFtcmpeul5yfu4kREktV
	OxjvfLU5xCjAwajEw6vIsydYiDWxrLgy9xCjBAezkgjvckGgEG9KYmVValF+fFFpTmrxIUYm
	Dk6pBkYGy6sp7dOM2D4vKCiY1vrb9/ekOsXslhXyZhfVayuTmafwrjfbPnM/N3f9FvcnSUyt
	wid5m37GVfFrxv+b81dZf07AJjGJ1+VM5pUf/XVaNUUNjwQvlVBWS7tWxnZiwk8jqZKayz+m
	iVr827hX6l99hPlTx5y0h272lVUbqnerJqw513FXQYmlOCPRUIu5qDgRADdtRreDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 05:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.48 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  9 23:58:20 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.48-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No demsg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
