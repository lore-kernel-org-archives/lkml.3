Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955Ab3DCMVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:21:47 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:52544 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761343Ab3DCMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
Date: Wed, 3 Apr 2013 14:21:42 +0200
Message-ID: <CACRpkdaDrK2Hqj-b5_QeCkrVBtCi5NgqiHpsOVmbEzerqY+MwQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: use dev_info instead of pr_info in pinctrl_select_state_locked
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

> And remove superfluous brackets.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> If it's not too late, it can be squashed with commit:
> 3102a76cfbf9ac4ae0cf54c7452f7ba4292a4760
> "pinctrl: disable and free setting in select_state in case of error"

Bah, applied as-is with Stephen's Review-tag.

Yours,
Linus Walleij
