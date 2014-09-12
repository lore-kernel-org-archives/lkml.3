Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaILWU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:20:58 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34997 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaILWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <1410430870.32479.0.camel@phoenix>
References: <1410430870.32479.0.camel@phoenix>
Date: Fri, 12 Sep 2014 15:20:55 -0700
X-Google-Sender-Auth: 2FBQC5QaUgQ6tLtikJtltn8y-y4
Message-ID: <CAD=FV=X-Li-wz77LOQY4EB924Cdjn0sQvo1tFs7qEZDuW5-uJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: rk808: Remove unused variables
From: Doug Anderson <dianders@chromium.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel,

On Thu, Sep 11, 2014 at 3:21 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Also remove non-informative comment.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/rk808-regulator.c | 26 --------------------------
>  1 file changed, 26 deletions(-)

Seems reasonable to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
