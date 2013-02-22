Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3BVJbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:31:10 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:60553 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3BVJbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:31:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130222092428.GA27937@avionic-0098.mockup.avionic-design.de>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
	<20130222065548.GA3252@b29396-Latitude-E6410>
	<1361516478.223331042@f282.mail.ru>
	<20130222071311.GB3252@b29396-Latitude-E6410>
	<20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
	<20130222082954.GD3252@b29396-Latitude-E6410>
	<20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
	<20130222092055.GF3252@b29396-Latitude-E6410>
	<20130222092428.GA27937@avionic-0098.mockup.avionic-design.de>
Date: Fri, 22 Feb 2013 17:31:05 +0800
Message-ID: <CAP1dx+wh-MUQqazb187+7js1Lf6da6ur3RsKjt-YKqhVdCaNPQ@mail.gmail.com>
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dong Aisheng <b29396@freescale.com>, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 17:24, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
...
>> I just tried update to latest linus tree, still did not find this API defined
>> in include/linux/io.h.
>> Would you mind point it out for me?
>
> Commit 75096579c3ac39ddc2f8b0d9a8924eba31f4d920 introduced it. The
> prototype is in include/linux/device.h and the implementation in
> lib/devres.c.
>
Got it.
Thanks.

Regards
Dong Aisheng
