Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3LBKiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:38:20 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54118 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3LBKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:38:19 -0500
MIME-Version: 1.0
In-Reply-To: <1385898066.5613.0.camel@phoenix>
References: <1385898066.5613.0.camel@phoenix>
Date: Mon, 2 Dec 2013 11:38:17 +0100
Message-ID: <CACRpkdbFhw7m0m+=2do=bgNkh3oBEn6sFUCnauCBj22mcAeLtw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: abx500: Fix header file include guard
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Patrice Chotard <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 1, 2013 at 12:41 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Fix a trivial typo.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied for fixes, thanks for spotting this!

Yours,
Linus Walleij
