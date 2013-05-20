Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3ETLmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:42:45 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36933 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3ETLmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:42:44 -0400
MIME-Version: 1.0
In-Reply-To: <1368710224.5500.1.camel@phoenix>
References: <1368710224.5500.1.camel@phoenix>
Date: Mon, 20 May 2013 13:42:43 +0200
Message-ID: <CACRpkda3BXjuvJvBam1fZMg5v_RBV7m7B0jfXoWYMpU60LL3ag@mail.gmail.com>
Subject: Re: [PATCH] power_supply: pm2301_charger: Return error if
 create_singlethread_workqueue fails
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anton Vorontsov <cbou@mail.ru>, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arun Murthy <arun.murthy@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 3:17 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Return error instead of 0 if create_singlethread_workqueue call fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
