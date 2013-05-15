Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3EOL3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:29:33 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52011 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3EOL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <1368543638-3299-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1368543638-3299-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 15 May 2013 13:29:32 +0200
Message-ID: <CACRpkdaBvzPWdNOCXd8VU4iiwAOKiP5Y-iic4qHhUeBVtYizHA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/lantiq: Free mapping configs for both pin and groups
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: John Crispin <blogic@openwrt.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 5:00 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> When creating mappings from DT both pin config and group config mappings
> are allocated. Free them both when destroying the mappings.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Applied to fixes with John's ACK, thanks!

Yours,
Linus Walleij
