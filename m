Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaEPPWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:22:04 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49810 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbaEPPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:22:03 -0400
MIME-Version: 1.0
In-Reply-To: <1399999332-23279-1-git-send-email-berthe.ab@gmail.com>
References: <1399999332-23279-1-git-send-email-berthe.ab@gmail.com>
Date: Fri, 16 May 2014 17:22:01 +0200
Message-ID: <CACRpkda2E7u9=7MH1v7MSUyH2Ubsi9vzxWE2X4LwHVV8Uzm3Eg@mail.gmail.com>
Subject: Re: [PATCH] gpio: janzttl: use devm function
From: Linus Walleij <linus.walleij@linaro.org>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 6:42 PM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

> This uses dem function for mem allocation
>
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>

Patch applied after fixing up some collission with the other
patch cleaning up the OOM exit path.

Yours,
Linus Walleij
