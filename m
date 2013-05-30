Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3E3SMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:12:33 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58750 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab3E3SM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-4-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-4-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:12:26 +0200
Message-ID: <CACRpkdb9vW6Jo0T+boW0hkF6AuRNb72MgFSgwzctO=U_4XB3Yg@mail.gmail.com>
Subject: Re: [PATCH 03/11] gpio: davinci: Modify to platform driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KV Sujith <sujithkv@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

Why not squash patch 1 into this patch?

Anyway, this bring us closer to the model of other drivers so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
