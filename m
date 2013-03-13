Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab3CMSDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:03:00 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:33233 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CMSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <1363161686-21616-1-git-send-email-haojian.zhuang@linaro.org>
References: <1363161686-21616-1-git-send-email-haojian.zhuang@linaro.org>
Date: Wed, 13 Mar 2013 19:02:59 +0100
Message-ID: <CACRpkdbYKMETmtTiUZ_cqF8W2LS8gL8XX00M2j2wo49p5AcfdQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: single: correct argument for pinconf
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: tony@atomide.com, linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 9:01 AM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:

> pcs_pinconf_set() is always using "arg << shift" to configure two
> parameters case. But pcs_add_conf2() didn't remove shift for config
> argument. So correct it.
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Tentatively applied, unless Tony diss it...

Yours,
Linus Walleij
