Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3JIFeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:34:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30688 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3JIFeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:34:07 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-28-5254ea7d0932
Message-id: <5254EA7B.80309@samsung.com>
Date: Wed, 09 Oct 2013 14:32:43 +0900
From: "sangjung.woo" <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
 <1381291649.2040.1.camel@joe-AO722> <5254DD64.4090205@samsung.com>
 <1381294767.2040.5.camel@joe-AO722>
In-reply-to: <1381294767.2040.5.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkULf2VUiQwZ1Tqhaz7z9msbi8aw6b
	xeYPL9ks9nd2MFr8PpnswOrR0tzD5rG19QCrx56JJ9k8vqy6xuzxeZNcAGsUl01Kak5mWWqR
	vl0CV0bz3SOMBbeYKv5/1W5g7GXqYuTkkBAwkfi2ZRszhC0mceHeerYuRi4OIYGljBLL7h1m
	gynq7nrAApFYxChx5txzKOc1o8SVR31go3gFNCSaDy4DSnBwsAioSlyaVA8SZhPQl/i4fDnY
	BlGBMIkl3x6zQZQLSvyYfA+sXERAUeLuFn6QkcwCkxgljuw5yA5SIyzgIdFyfi8zxK7NjBLr
	m5ezgiQ4BQwkpp4+CmYzC1hLrJy0jRHClpfYvOYtWIOEwD52iUeTZrOAJFgEBCS+TT4Etk1C
	QFZi0wGolyUlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNz
	NzECI+z0v2f9OxjvHrA+xJgMtHIis5Rocj4wQvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDi16dZ2HeHZK4sFxZpWfmFsV2hcau632vXoOeGb
	Cf5s+8PqNE1DPPv3p6wz6vH7GaUgHO6VG7824lwh65yVt799Pb/uG7vfH4MZbWJ+XHaFfVNe
	n+999rud53iprSkL98ZdH3k7C1P3lJWwd9ttXb5+RoDCg0uHVj04J7mONyqAu43/67HVK5RY
	ijMSDbWYi4oTATXg9pDGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd3aVyFBBtNeylnMvv+YxeLyrjls
	Fps/vGSz2N/ZwWjx+2SyA6tHS3MPm8fW1gOsHnsmnmTz+LLqGrPH501yAaxRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZzXePMBbcYqr4/1W7gbGXqYuRk0NCwESiu+sB
	C4QtJnHh3nq2LkYuDiGBRYwSZ849Z4FwXjNKXHnUB9bBK6Ah0XxwGVCCg4NFQFXi0qR6kDCb
	gL7Ex+XLmUFsUYEwiSXfHrNBlAtK/Jh8D6xcREBR4u4WfpCRzAKTGCWO7DnIDlIjLOAh0XJ+
	LzPErs2MEuubl7OCJDgFDCSmnj4KZjMLWEusnLSNEcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG
	5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH7THoH46oGi0OMAhyMSjy8D/hDgoRYE8uK
	K3MPMUpwMCuJ8OYtBArxpiRWVqUW5ccXleakFh9iTAaGwERmKdHkfGBqySuJNzQ2MTOyNDI3
	tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxopNOoofmNYJMV/qaG6bqVQlnx05
	Z53HXqn3Cw/pLdj51e1Ve7vjouZHncUTOXdc3DZ1ocyuWq2Z6keqV8x9dbh6tU1jjKLyFJkD
	cTpRt97sYD9kez3J5Oasu2F2jb8+rJjBfc6SNcj91c8tZj2VLxcH8isI2L43mhwsNvNUR0H7
	pXdMQSxR25RYijMSDbWYi4oTAazk818jAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 01:59 PM, Joe Perches wrote:
> The commit message doesn't match the patch subject
> (shows kzalloc)
>
> I was a bit surprised to find there isn't a devm_kmalloc.
>
> This seems fine otherwise.

I just sent the second patch file after modifying the commit message.
Thank you for your opinion.

Cheers,
Sangjung Woo
>

