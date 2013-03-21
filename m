Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3CUS2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:28:20 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:38366 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CUS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <1363864907-28351-1-git-send-email-richard.genoud@gmail.com>
References: <5149ED25.4010309@wwwdotorg.org>
	<1363864907-28351-1-git-send-email-richard.genoud@gmail.com>
Date: Thu, 21 Mar 2013 19:28:19 +0100
Message-ID: <CACRpkda7FG6ET1FGod_BVk-nM3mg6WEwvsfB=s0yQCT+1ULDaQ@mail.gmail.com>
Subject: Re: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:21 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> If pin_free is called on a pin already freed, mux_usecount is set to
> UINT_MAX which is really a bad idea.
> This will issue a warning, so that we can correct the code responsible
> for the double free.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

This version of the patch applied with Stephen's Reviewed-by
and BUG prefix stripped, it's applied to the fixes branch for
the v3.9 release candidates.

Yours,
Linus Walleij
