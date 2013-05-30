Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3E3URY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:17:24 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55721 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3E3URK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <1369776584-15271-1-git-send-email-n.a.balandin@gmail.com>
References: <1369776584-15271-1-git-send-email-n.a.balandin@gmail.com>
Date: Thu, 30 May 2013 22:17:10 +0200
Message-ID: <CACRpkdZZ-m7XL8tpQtu3sOK2M4PVyLmMAn5r53L7Wg48tCkf5A@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] gpio: sx150x: convert to use devm_kzalloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Nikolay Balandin <n.a.balandin@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:29 PM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:

> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> Use devm_kzalloc() to make cleanup paths simpler.
>
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Patch applied.

What is wrong with you RTC?

Received: from localhost.localdomain
(ppp91-76-159-237.pppoe.mtu-net.ru. [91.76.159.237])
        by mx.google.com with ESMTPSA id t4sm17535255lbe.7.2013.05.30.12.21.07
        for <multiple recipients>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 30 May 2013 12:21:08 -0700 (PDT)
(...)
Subject: [PATCH v2 1/1] gpio: sx150x: convert to use devm_kzalloc()
Date: Tue, 28 May 2013 14:29:44 -0700

The mail was clearly sent today but looks two days old.

Yours,
Linus Walleij
