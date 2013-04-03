Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520Ab3DCM2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:28:31 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64396 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab3DCM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <1364471748-23192-3-git-send-email-richard.genoud@gmail.com>
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
	<1364471748-23192-3-git-send-email-richard.genoud@gmail.com>
Date: Wed, 3 Apr 2013 14:28:25 +0200
Message-ID: <CACRpkdZX7Pe1BQtC5_p6nK7CV=uie31QW8+eKr6UxgU8FAWRaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: pinctrl_select_state: set the old_state back
 on error
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

> In unapply_new_state, the old state is re-applied, but p->state is not
> set back as it should.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> This one can be squshed with commit:
> 50cf7c8ab324de348990bb028ad9ed10872d527a
> pinctrl: re-enable old state in case of error in pinctrl_select_state
> If needed.

Applied with Stepgen's Review-tag.

Thanks,
Linus Walleij
