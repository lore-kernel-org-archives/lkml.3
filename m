Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576Ab3DCM0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:26:44 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:55972 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762502Ab3DCM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <1364471748-23192-2-git-send-email-richard.genoud@gmail.com>
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
	<1364471748-23192-2-git-send-email-richard.genoud@gmail.com>
Date: Wed, 3 Apr 2013 14:26:41 +0200
Message-ID: <CACRpkdZJ-2NSePwS0X=F=hkMxsw0_QmXWSb0ZegQ60pAOdv1UQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: remove superfluous optimization in pinctrl_select_state_locked
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:55 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> As Stephen Warren suggested, checking first if the setting->node entry
> is the first in the list or not is superfluous, as it is checked again
> in the list_for_each_entry bellow.
> So, remove it, the code will be simpler and lighter !
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> If can also be squashed whit commit:
> 3102a76cfbf9ac4ae0cf54c7452f7ba4292a4760
> "pinctrl: disable and free setting in select_state in case of error"
> (But there will be a conflict on "if (old_state)" vs "FIXME comment")

Applied with Stephen's Reviewed tag.

Thanks,
Linus Walleij
