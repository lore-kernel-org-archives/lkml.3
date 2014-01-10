Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaAJAaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:30:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19166 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaAJAaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:30:05 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-d9-52cf3f0b548c
Message-id: <52CF3F0B.8030006@samsung.com>
Date: Fri, 10 Jan 2014 09:30:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jesper Falk <jesperfalk94@gmail.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Power: charger-manager: Fixed coding style
References: <1389023175-11872-1-git-send-email-jesperfalk94@gmail.com>
In-reply-to: <1389023175-11872-1-git-send-email-jesperfalk94@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkWJfb/nyQwe+pshYHt2paTFw5mdmi
	sX0hk8XlXXPYHFg8JvR/YvTYOesuu8fmFVoenzfJBbBEcdmkpOZklqUW6dslcGV0zdjKXNDK
	XPF/zSLGBsadTF2MnBwSAiYSxx5chbLFJC7cW8/WxcjFISSwlFHi/4ROuKK7N18yQySmM0os
	WjqXBcJ5xSixsn8KexcjBwevgJZEb7MzSAOLgKrEp0v/WEFsNqDw/hc32EBsUYEwiZXTr7CA
	2LwCghI/Jt8Ds0UENCQW/u0Gq2cWcJfY2/iTEcQWFrCXaNjRCNYrJOAm8f3iV7AaTqCaD8/X
	M0HU60jsb53GBmHLS2xe8xbsUAmBdewSq341sUAcJCDxbfIhFpA7JQRkJTYdYIZ4TFLi4Iob
	LBMYxWYhOWkWkrGzkIxdwMi8ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwlk7/e9a7g/H2
	AetDjMlAKycyS4km5wNjMa8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGIPlVnz6kbX+3ZFC1sexJkyXm7jlnsq+k3+RL1/k+ulHhOmWSTPXJe9V
	KXePXLI0WHYa8/kvk5wyiwsuTnypwbPUOG9fl8cxkesnk+2mCC6ZzPJjl/+UkydDj+lsnRSx
	Y8W0vG9Jq+QNk9NKL02QfqHLXNFl9etpgrVt6MGge5sdmIoO9Nq1CSuxFGckGmoxFxUnAgAD
	4yKeuwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoC63/fkgg755YhYHt2paTFw5mdmi
	sX0hk8XlXXPYHFg8JvR/YvTYOesuu8fmFVoenzfJBbBENTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmdM3YylzQylzxf80ixgbGnUxdjJwcEgImEndvvmSGsMUkLtxbz9bF
	yMUhJDCdUWLR0rksEM4rRomV/VPYuxg5OHgFtCR6m51BGlgEVCU+XfrHCmKzAYX3v7jBBmKL
	CoRJrJx+hQXE5hUQlPgx+R6YLSKgIbHwbzdYPbOAu8Texp+MILawgL1Ew45GsF4hATeJ7xe/
	gtVwAtV8eL6eCaJeR2J/6zQ2CFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIER+oz6R2MqxosDjEKcDAq8fCuKD4bJMSaWFZcmXuIUYKDWUmEN83q
	fJAQb0piZVVqUX58UWlOavEhxmRgCExklhJNzgcmkbySeENjEzMjSyNzQwsjY3PShJXEeQ+2
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYMyS9pojHxHCMu/1HhWtn/dW+k38umNRRGBw9/bymnvr
	zCXSn1gcNfU1D1IK2T6fZaPJjOZZpatf3c4QPy2h6PR9qdbdb+pRxsmfj4hkm33N9pivkmOy
	qeVHrgdTfCLP5p8CG9fnXt7oejq565mA4YkqqYp9MZPEfj0Iu6RV9WxjfPrb8s59G5RYijMS
	DbWYi4oTAY7mWxYYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 12:46 AM, Jesper Falk wrote:
> Removed apaces before semicolon and fixed brackets on if statements
> 
> Signed-off-by: Jesper Falk <jesperfalk94@gmail.com>
> ---
>  drivers/power/charger-manager.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 

Acked-by: Chanwoo Choi

I reviewed and tested this patch.

Thanks,
Chanwoo Choi

