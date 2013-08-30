Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3H3IiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:38:01 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45923 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3H3Ih6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <1377851485.14643.1.camel@phoenix>
References: <1377851485.14643.1.camel@phoenix>
Date: Fri, 30 Aug 2013 10:37:58 +0200
Message-ID: <CACRpkdaK=nahmUKGxO3y4Nk-DVtz5Bj9WD+cXW6QpYCNaB2awQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sunxi: Fix off-by-one for valid offset range checking
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:31 AM, Axel Lin <axel.lin@ingics.com> wrote:

> The valid offset range should be 0 ... chip->ngpio - 1.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.

Yours,
Linus Walleij
