Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3IJQvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:51:17 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:49411 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3IJQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:51:15 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130910153543.GB11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
	<1378817379-8238-8-git-send-email-lee.jones@linaro.org>
	<CAOesGMj+YzkE5bAxUqFYWoJ-RURDdCK5MUWYTc+gWFQMB3KWkg@mail.gmail.com>
	<20130910153543.GB11227@lee--X1>
Date: Tue, 10 Sep 2013 09:51:14 -0700
Message-ID: <CAOesGMhSLnSeJ29zYf0kjxDWEtN5gwmumOgJFKUruYACaB9Dzw@mail.gmail.com>
Subject: Re: [PATCH 07/38] ARM: ux500: CONFIG: Enable ST's IIO Accelerometer
 Sensors by default
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jic23@cam.ac.uk, Arnd Bergmann <arnd@arndb.de>,
        LinusW <linus.walleij@linaro.org>, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 8:35 AM, Lee Jones <lee.jones@linaro.org> wrote:

>> splitting this and the other config update into two patches? Really?
>
> I haven't split anything. I created the patches as I was
> enabling/testing the drivers, which was at completely different
> times. The only reason they're close together in the set is because I
> reorganised it and didn't think it was necessary to squash them
> together.

In this case, squashing makes a lot of sense. But you could even have
LinusW do that for you when he pulls in the various config updates for
next release.


-Olof
