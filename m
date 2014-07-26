Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaGZIah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:30:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64613 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGZIaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:30:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53D3672A.20206@roeck-us.net>
Date: Sat, 26 Jul 2014 01:30:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bug on Boot of Ubuntu 14.04 with kernel 3.16 r6 release
References: <CAPDOMVjiT8JKyzLdcFpVVC337p9nC=V66MjePk+1KwNm3owZQg@mail.gmail.com>
In-Reply-To: <CAPDOMVjiT8JKyzLdcFpVVC337p9nC=V66MjePk+1KwNm3owZQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 06:34 PM, Nick Krause wrote:
> Hey Guys,
> After building my first rc kernel. I am sad to state it doesn't
> boot.It states that it can't find my root uuid for my ssd boot drive.
> I am using GSP with UEFI, on a Sandy Bridge i5 2500k build I have  had
> for a few years. The kernel boots and after a few seconds
> drops to a busybox ash shell stating it can't find my root device. I
> am using the default Ubuntu build for this and it did boot
> before with x86_64 defconfig without my sound through. Seems to me an
> issue with the Ubuntu built kernel and not upstream
> at least from what I can tell. I will attach my .config to help
> through or my sound drivers.

I'd put in a wild guess that you did not install a matching initramfs.

Guenter

