Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762619Ab3DCMjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:39:24 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:52881 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760335Ab3DCMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <1364547807-22370-2-git-send-email-richard.genoud@gmail.com>
References: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
	<1364547807-22370-2-git-send-email-richard.genoud@gmail.com>
Date: Wed, 3 Apr 2013 14:39:22 +0200
Message-ID: <CACRpkdbR4NGxySrNvkDFWr+ehw_Qaawz_+61r0NdCwY1kcDtxw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: simplify the re-enable old state code in pinctrl_select_state
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 10:03 AM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> Instead of just enabling the settings that were disabled in the 1st
> loop, it's simpler to recall pinctrl_select_state with the old state.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Patch applied with Stephen's review tag.

Thanks,
Linus Walleij
