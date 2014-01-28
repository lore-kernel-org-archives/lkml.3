Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaA1Rlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:41:50 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:65048 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaA1Rls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:41:48 -0500
X-AuditID: cbfec37d-b7ff46d000005528-3a-52e7ebda99b3
Message-id: <52E7EBCF.1000009@samsung.com>
Date: Tue, 28 Jan 2014 10:41:35 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 00/10] 3.13.1-stable review
References: <20140127201535.350372282@linuxfoundation.org>
In-reply-to: <20140127201535.350372282@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX91br58HGez+JG8xZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfG4xefmQqOslc0fOpkamD8y9rFyMkhIWAisXHmAmYIW0ziwr31bCC2kMAyRold/wIh
	7F4midV/U7sYuYDsDYwS638sZAJJ8ApoSXz++4QdxGYRUJVomPMELM4moC7x+fUOdohmOYmm
	JavBFogKREi8OjuRBaJXUOLH5HtgtohAsMTarwsZQRYwC6xglDj+8iXYFcJA1zU23GOGGGQl
	sXFtB9hQTgFriQWLv4PZzED2yknbGCFseYnNa95C1StL/Ll8igniMwWJR1db2ScwisxCsnsW
	kvZZSNoXMDKvYhQrLU4uKE5KT60w0StOzC0uzUvXS87P3cQIiZnaHYz3v9ocYhTgYFTi4Q04
	/zxIiDWxrLgy9xCjBAezkgjvrd1AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw6jaybF5an8hvt
	PKu66H1Q5J+C0ru1Zy6uPGkoe81hz3IZqUyG0BXW32a7bN1TUzWN8+env/1n2/b8WZEteKTx
	y+9EO8716xl7Ki41der5lkwVmRH/d69M4Nu1FS5aPnyGdt2fF5cu8nuzPdCUK2WitOXiRxee
	dvoJSnkVz/Ztu+x5M/GQ6yclluKMREMt5qLiRACb5gXXdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 01:17 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.1 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jan 29 20:15:25 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.1-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing - passed
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed - no regressions in emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
