Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaKRXyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:54:17 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37162 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaKRXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:54:16 -0500
Message-ID: <546BDBE7.4040604@au1.ibm.com>
Date: Wed, 19 Nov 2014 10:53:11 +1100
From: Jeremy Kerr <jeremy.kerr@au1.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices
 with an OF node
References: <1415342031.4925.27.camel@kernel.crashing.org> <1415342117.4925.29.camel@kernel.crashing.org> <1415596626.5769.14.camel@kernel.crashing.org> <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com> <1415841047.5124.62.camel@kernel.crashing.org> <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com> <546BD8BD.2010605@au1.ibm.com>
In-Reply-To: <546BD8BD.2010605@au1.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111823-0025-0000-0000-00000087F1C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

> struct device doesn't have an of_node member if !CONFIG_OF, so we'll
> need to disable this block in the preprocessor.

Scratch that, I was looking at the wrong header - we do indeed have the
of_node available independently of CONFIG_OF, and this makes the logic a
little cleaner.

Cheers,


Jeremy

