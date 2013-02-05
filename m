Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3BEOzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:55:49 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:49219 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab3BEOzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:55:48 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-9-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-9-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:55:48 +0100
Message-ID: <CACRpkdZQ8WrSAENX9GONGg0=yGh16=i+SwDg2SRwfuHQkxopvg@mail.gmail.com>
Subject: Re: [PATCH 09/11] PINCTRL: lantiq: add functionality to falcon_pinconf_dbg_show
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Thomas Langer <thomas.langer@lantiq.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:05 PM, John Crispin <blogic@openwrt.org> wrote:

> The current code only has a stub for falcon_pinconf_dbg_show. This patch adds
> proper functionality.
>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Applied to my devel branch.

Makes me think again I want a patch for this to use
generic pinconfig.

Yours,
Linus Walleij
