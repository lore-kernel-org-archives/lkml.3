Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbaEWHuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:50:55 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33274 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaEWHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:50:54 -0400
MIME-Version: 1.0
In-Reply-To: <537EF50B.2010101@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<537EF50B.2010101@linaro.org>
Date: Fri, 23 May 2014 09:50:53 +0200
Message-ID: <CAPDyKFpTXrURM8OzNjO-RRfCFWGct4+_M4D8COdEurUhY46GWg@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] Add Qualcomm SD Card Controller support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 09:13, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> Hi Ulf,
> I like to get this patches for v3.16,  any chance of considering these
> patches to v3.16 ?

I promise to have them properly reviewed early next week, sorry for
taking so long. Let's see where this leads us.

It seems like you had some CRC issues during read/write? Did you
manage to resolve that issue?

Kind regards
Ulf Hansson
