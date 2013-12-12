Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3LLT6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:58:23 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46586 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3LLT6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:58:21 -0500
MIME-Version: 1.0
In-Reply-To: <1386679620.7152.226.camel@host5.omatika.ru>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	<1386348542-9584-1-git-send-email-ynvich@gmail.com>
	<CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
	<1386679620.7152.226.camel@host5.omatika.ru>
Date: Thu, 12 Dec 2013 20:58:21 +0100
Message-ID: <CACRpkda2qpHbRKu3WuHs9wApMZ83BW8etBc5Uz095pyvBsWWOQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Linus Walleij <linus.walleij@linaro.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:47 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
> On Tue, 2013-12-10 at 13:43 +0100, Linus Walleij wrote:
>> Argh! Now you're adding another user for a legacy custom pin control
>> implementation. But if noone is going to modernize PXA2xx what
>> can we do :-/
>
> I've rewritten the device to use device tree and posted patch series for
> that.

THANKS! For doing this.

Yours,
Linus Walleij
