Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3EQNp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:45:57 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:61032 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3EQNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <1368696660.8439.1.camel@phoenix>
References: <1368696660.8439.1.camel@phoenix>
Date: Fri, 17 May 2013 15:45:55 +0200
Message-ID: <CACRpkdYxgOFZU6GudXbkEgnrqZZ-Mv6zwR3K_U3ZXjNhj8PbfA@mail.gmail.com>
Subject: Re: [PATCH] power_supply: pm2301_charger: Fix NULL pointer dereference
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anton Vorontsov <cbou@mail.ru>, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:31 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Add checking pl_data in probe, this prevent possible NULL pointer dereference.
> Also fix NULL pointer deference in dev_err when allocate memory for pm2 fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
