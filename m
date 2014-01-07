Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaAGTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:09:58 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:33498 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaAGTJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:09:47 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-bd-52cc50fa91ae
Message-id: <52CC50F8.8040906@samsung.com>
Date: Tue, 07 Jan 2014 12:09:44 -0700
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
Subject: Re: [PATCH 3.4 00/43] 3.4.76-stable review
References: <20140106223942.259651490@linuxfoundation.org>
In-reply-to: <20140106223942.259651490@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP93fAWeCDOZsYbWYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStj3uuZzAWNXBW3DpxlbmD8yN7FyMkhIWAicfz5OxYIW0ziwr31bF2MXBxCAssYJW4+
	WcoC4fQySWye+Z0ZwtnIKHFu5WmgDAcHr4CWxLcXHCDdLAKqEltfrGACsdkE1CU+v94BtkFI
	QE6iaclqZhBbVCBC4tXZiWDbeAUEJX5MvgdmiwgES6z9upARZD6zwApGieMvX7KBJIQFjCUe
	TljFCDHISmLfw2lgQzkFrCXmnlwIFmcWMJN41LKOGcKWl9i85i0zRL2yxJ/Lp5hA7pQQUJTY
	vtpqAqPILCSrZyHpnoWkewEj8ypGsdLi5ILipPTUCiO94sTc4tK8dL3k/NxNjJCYqd7BePer
	zSFGAQ5GJR7eG2pngoRYE8uKK3MPMUpwMCuJ8AZ5AYV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	TnK4eXyLjUlrWEcR+4JpV2ouX1/LtKTmkO/b62++8Kq+WLV7276SOUwxl+O2+/kwTFb71nfA
	/TVjwpXafWZ+a1Q5F0fZ6jmn2c16NlUz4kPgkTU3TV63Vn/Uz700X1z8X02tWkvueot9Souy
	9jBuFNrzaerugIWnFPebbD7wfu+WkEkKWbe5VJVYijMSDbWYi4oTASBle1R3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 03:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.76 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jan  8 22:39:27 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.76-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches testing - passed
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

Detailed test status

Patches applied cleanly
dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
