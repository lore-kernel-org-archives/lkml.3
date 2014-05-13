Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbaEMJmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:42:37 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40309 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203AbaEMJmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:42:33 -0400
MIME-Version: 1.0
In-Reply-To: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
References: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
Date: Tue, 13 May 2014 11:42:32 +0200
Message-ID: <CACRpkdZi=8ziAh4G2uG4Whw4tyzCtLqM=Dm469-Ltp67N8Eaxw@mail.gmail.com>
Subject: Re: [PATCH] gpio: using devm functions for timberdale gpio memory
 allocation This eases memory allocation and provides appropriate logging
From: Linus Walleij <linus.walleij@linaro.org>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 3:21 AM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>

Good patch, so I fixed up the commit message and applied it.

Yours,
Linus Walleij
