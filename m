Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3JWIqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:46:34 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:65191 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JWIqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8j82eWmhC6S=JrPgRu30rUspT-yatLYQ1KDnzyj8CcXw@mail.gmail.com>
References: <CAPgLHd8j82eWmhC6S=JrPgRu30rUspT-yatLYQ1KDnzyj8CcXw@mail.gmail.com>
Date: Wed, 23 Oct 2013 10:46:32 +0200
Message-ID: <CACRpkdYB6J6=bhEF+ko0EGOu2Rf_91oTk=eOZAXsmYcyLuPGSQ@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: tb10x: use module_platform_driver to
 simplify the code
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 4:55 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> module_platform_driver() makes the code simpler by eliminating
> boilerplate code.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.

Yours,
Linus Walleij
