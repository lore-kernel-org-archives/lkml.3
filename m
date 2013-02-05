Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3BEO5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:57:38 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:45416 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3BEO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-8-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-8-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:57:34 +0100
Message-ID: <CACRpkdYZ3903B-z2sWO+j19WyRPVdZZjqPFYYX+aRuhC5M=DBg@mail.gmail.com>
Subject: Re: [PATCH 08/11] PINCTRL: lantiq: fix pinconfig parameters
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Thomas Langer <thomas.langer@lantiq.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:05 PM, John Crispin <blogic@openwrt.org> wrote:

> The Falcon driver only defined the pinconf parameters but did not pass them
> properly to the underlying api.
>
> Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Patch applied, thanks.

Yours,
Linus Walleij
