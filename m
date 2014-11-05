Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaKELSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:18:47 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbaKELSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:18:43 -0500
Message-ID: <545A0790.2050302@nod.at>
Date: Wed, 05 Nov 2014 12:18:40 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: santosh nayak <santoshprasadnayak@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: How to access Linux Kernel environment Variables ?
References: <CAOD=uF4L+jvR=ckMdo3o4wdSsRcGynQnv_KOpDeyJst74YOxuA@mail.gmail.com>	<CAFLxGvywuEox+2fYZ-+ZLop=Za7Kum8P+q1kHx3cFWF2nG6O5A@mail.gmail.com> <CAOD=uF6oBZ0cmNH4Jf9Hs4ZU3Y4WO-wfvc4k0b7Ezpo63S7Dag@mail.gmail.com>
In-Reply-To: <CAOD=uF6oBZ0cmNH4Jf9Hs4ZU3Y4WO-wfvc4k0b7Ezpo63S7Dag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 11:56 schrieb santosh nayak:
> Thanks Richard for your response.
> 
> Is there any system call in Linux which can access and set variables
> in /proc/cmdline ?  (Similar to kenv() in FreeBSD which can access and
> set variables in /boot/loader.conf).

No.

> I would like to use that system call in linux C code, the  way I am
> using kenv() in freeBSD environment.

Create a wrapper function which behaves like kenv().
Should be doable in a few lines of code.

Thanks,
//richard
