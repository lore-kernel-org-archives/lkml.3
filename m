Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3HGSw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:52:56 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64741 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab3HGSwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
References: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 7 Aug 2013 20:52:54 +0200
Message-ID: <CACRpkdbmQJom3qYpg31iRcg=rEhn=xn0ZFmUm6UaS98BZ4-Gkg@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: st: Convert to use devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 6:22 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> devm_request_and_ioremap is deprecated. Use devm_ioremap_resource
> instead.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied with Srinivas ACK.

Thanks!
Linus Walleij
