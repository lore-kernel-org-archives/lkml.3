Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbaBEUlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:41:13 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:25915 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaBEUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:41:08 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-9f-52f2a1e25699
Message-id: <52F2A1DE.4060009@samsung.com>
Date: Wed, 05 Feb 2014 13:41:02 -0700
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
Subject: Re: [PATCH 3.13 000/140] 3.13.2-stable review
References: <20140204211036.967663852@linuxfoundation.org>
In-reply-to: <20140204211036.967663852@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP93HCz8FGcw9zWIxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfG+oazzAVTOSo+L3jO3MC4n62LkZNDQsBEYuvRjawQtpjEhXvrgeJcHEICyxglVn0/
	zQLh9DJJnLi2lgWkSkhgA6PErHOaIDavgJbEx09XmUFsFgFViYVHzoLZbALqEp9f72CHqJeT
	aFqyGiwuKhAh8ersRBaIXkGJH5PvgdkiAsESa78uZARZxiywglHi+MuXYOcJC5hJzPzwhAli
	kJXE7tsHwRo4BawltrTuYgSxmYFqHrWsY4aw5SU2r3nLDFGvLPHn8ikmiNcUJFbceMMygVFk
	FpLds5C0z0LSvoCReRWjWGlxckFxUnpqhZFecWJucWleul5yfu4mRkjUVO9gvPvV5hCjAAej
	Eg/vhzmfgoRYE8uKK3MPMUpwMCuJ8J6YDhTiTUmsrEotyo8vKs1JLT7EyMTBKdXAODlGJXXv
	won9p/nXuAoEnmyzOzXtwLHXyxon+SYFdKtsWK9xKOWCySa+9z5zwqXPHWnbe+19G+Piefcn
	rbB7fPZa8lS/K/cTN/9kXf3vmn3XzsWF7R94VnDUqdT5nzvauKNJjL0lYl7NtT8ir642LK8s
	+regQf3XibyCX1IsHu85m7IcXE9uXqvEUpyRaKjFXFScCACoud6LeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 02:09 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.2 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb  6 21:10:18 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.2-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly. boot tests passed on all test systems. No dmesg 
regressions: emerg, crit, alert, err are clean. No regressions in warn.

Minor Note: git apply --index complained about extra white space at the 
end of patch file. patch -p1 worked just fine.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
