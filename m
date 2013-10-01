Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3JATY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:24:57 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:35055 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3JATYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:24:54 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-0e-524b218537a2
Message-id: <524B2183.10701@samsung.com>
Date: Tue, 01 Oct 2013 13:24:51 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/17] 3.0.98-stable review
References: <20130929190757.138351117@linuxfoundation.org>
In-reply-to: <20130929190757.138351117@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX91WRe8gg303VSzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mr4vHMxc8Eh7oqrR76xNTAu5Oxi5OSQEDCReDXpDxOELSZx4d56ti5GLg4hgWWMEn/b
	m6CcXiaJvvVvGEGqhAQ2MkoseecKYvMKaEgsfdLPCmKzCKhKdOyezQxiswmoS3x+vYMdol5O
	omnJarC4qECExMolD1ghegUlfky+xwJiiwgYS/SfnQVWzyxwjFFiYbNJFyMHh7CAlsTClkSI
	MVYSZxe+ZwOxOQWsJT6u2sECUW4tsXLSNkYIW15i85q3zBD1yhJ/Lp9iAhkjIaAosX211QRG
	kVlIFs9C0j0LSfcCRuZVjGKlxckFxUnpqRXGesWJucWleel6yfm5mxgh8VKzg/HeV5tDjAIc
	jEo8vAWPvYKEWBPLiitzDzFKcDArifD28nsHCfGmJFZWpRblxxeV5qQWH2Jk4uCUamBc//9M
	Fq/xngPtO6o/C3a7F3mJfnr9bPm1z7OM/x4y8krfbPf6+JejGpI9NQ+Lligt2Hcyn+nVnWfX
	I6OnxpwN0fi8J3O58m//yPCXwrkT5sTtVd/Hlrm899ruK7q5t3rD/rf6HHzY9EJvneO2vqKX
	EU3O/fd1rQ7VPpskWJMZbHFgj9BJn+hLSizFGYmGWsxFxYkAFnNarXUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 01:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.98 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:07:47 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.98-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.0.98-rc1 applied cleany to 3.0.97

Compiled and booted on the following systems:

HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: not applicable
blackfin: defconfig passed
c6x: not applicable
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
