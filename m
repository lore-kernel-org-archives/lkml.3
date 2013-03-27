Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3C0WSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:18:54 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:41430 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3C0WSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
	<1364222843-30305-5-git-send-email-richard.genoud@gmail.com>
Date: Wed, 27 Mar 2013 23:18:52 +0100
Message-ID: <CACRpkdZhb2+z4nx6x+C0D54cHd54PyfdFB4sB400gcr0Pz9qsw@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: re-enable old state in case of error in pinctrl_select_state
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 3:47 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> If a new state is applied, the groups configured in the old state but
> not in the new state are disabled.
> If something goes wrong and the new state can't be applied, we have to
> re-enable those groups.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Another very tasty patch, applied!

Thanks!
Linus Walleij
