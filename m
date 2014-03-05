Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaCEWbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:31:41 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:61505 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbaCEWbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:31:36 -0500
X-AuditID: cbfec37d-b7f616d0000059df-77-5317a5c69da5
Message-id: <5317A5C4.2070307@samsung.com>
Date: Wed, 05 Mar 2014 15:31:32 -0700
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
Subject: Re: [PATCH 3.10 00/97] 3.10.33-stable review
References: <20140304200345.895517495@linuxfoundation.org>
In-reply-to: <20140304200345.895517495@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.11]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX93jS8WDDRZeZbWYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvjweW7zAWN7BXP7l9ja2A8ydrFyMkhIWAicff3bjYIW0ziwr31QDYXh5DAMkaJWctm
	MUM4vUwSj/qvskA4mxglji5/CtbCK6Al0f9/AguIzSKgKnH15l2wOJuAusTn1zvYQWwhATmJ
	piWrmUFsUYEIiVdnJ7JA9ApK/Jh8D8wWEQiWWPt1ISPIAmaBFYwSx1++BBskLGAqsbXjOyPE
	ICuJLXceMoHYnALWEk+WrQSLMwuYSTxqWccMYctLbF7zlhmiXlniz+VTQPUcQL8pSvz67z6B
	UWQWktWzkHTPQtK9gJF5FaNYaXFyQXFSemqFiV5xYm5xaV66XnJ+7iZGSNTU7mC8/9XmEKMA
	B6MSD+8GP/FgIdbEsuLK3EOMEhzMSiK8AZFAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYztupuc
	in5ybFXVqLoVf6L71bt/PtqPczrzFjyc2npxwYlg5d/mN4/mreByePtOweWOo/23DRNqti9g
	mrf0v/iOdQYq7NMXZ314qWghIf2aUyxcg+HqohsXjthvW/q1vY3HsOpj7/fkFhOJ+TH2aRzN
	PRFxu9+//npztnr8V9WHSfM3TAvyvrdOiaU4I9FQi7moOBEAxqK+uHgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 01:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.33 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar  6 20:03:11 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.33-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
