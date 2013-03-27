Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3C0WSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:18:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61458 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3C0WR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
	<1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
Date: Wed, 27 Mar 2013 23:17:58 +0100
Message-ID: <CACRpkdaJorfhwY2CBAVx9B3fmAsG+3bZHv+3bAkxiuvbEWvZZA@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: disable and free setting in select_state in
 case of error
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 3:47 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> If enabling a pin fails in pinctrl_select_state_locked(), all the
> previous enabled pins have to be disabled to get back to the previous
> state.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Thanks for fixing this! :-D

Patch applied.

Yours,
Linus Walleij
