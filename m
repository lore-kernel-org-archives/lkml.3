Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3COJbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:31:36 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59028 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3COJbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <514270D2.9010205@asianux.com>
References: <51415428.1070401@asianux.com>
	<20130314234323.GD4977@n2100.arm.linux.org.uk>
	<514270D2.9010205@asianux.com>
Date: Fri, 15 Mar 2013 10:31:33 +0100
Message-ID: <CAAQYJAvXLV38shKncAKKqgQ9G0SnXjh+=aJHBdhd29yzVtL80A@mail.gmail.com>
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
From: Andrea Adami <andrea.adami@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, matthew.leach@arm.com,
        dave.martin@linaro.org, nico@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 1:52 AM, Chen Gang <gang.chen@asianux.com> wrote:
> 于 2013年03月15日 07:43, Russell King - ARM Linux 写道:
>> So our wonderful toolchain has decided to start producing NULL warnings
>> for every "mcr     p15, 0, rX, c7, c10, 4" instruction?  I'd just ignore
>> them and hope that the toolchain people fix it.

AFAIK Arnd is aware and waiting for feedback about his patch:

ARM: compressed/head.S: work around new binutils warning   Arnd Bergmann

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/144846.html

Regards

Andrea
>
>   ok, thanks.
>
>   :-)
>
> --
> Chen Gang
>
> Asianux Corporation
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
