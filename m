Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3COLMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:12:15 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39876 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3COLMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:12:14 -0400
Message-ID: <514301E8.9040201@gmail.com>
Date: Fri, 15 Mar 2013 19:11:36 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Andrea Adami <andrea.adami@gmail.com>,
        Chen Gang <gang.chen@asianux.com>, matthew.leach@arm.com,
        dave.martin@linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, nico@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        matthew.gretton-dann@linaro.org
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
References: <51415428.1070401@asianux.com> <514270D2.9010205@asianux.com> <CAAQYJAvXLV38shKncAKKqgQ9G0SnXjh+=aJHBdhd29yzVtL80A@mail.gmail.com> <201303151056.55819.arnd@arndb.de>
In-Reply-To: <201303151056.55819.arnd@arndb.de>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月15日 18:56, Arnd Bergmann 写道:
> Right. The fact that as prints a warning for those instructions makes sense
> given that we are telling it we want to run on *all* ARM architectures,
> and that ARMv8 has deprecated them officially.
> 
> Of course, what is bogus about this is the "NULL" part rather than printing
> the text that was meant to come out to explain the situation.  I don't
> know how to report that bug other than what I tried before, but if it gets
> fixed by printing the right text, we will still want to build a kernel
> without getting any warnings.

  excuse me, my English is not quite well.

  I guess your meaning is:
    "that bug" means the toolchain's bug (need toolchain people fix it).
    prefer to apply your patch, before "that bug" is fixed (we don't know when)

  is it correct ?

  thanks.

-- 
Chen Gang

Flying Transformer
