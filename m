Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaEVV5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:57:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:50170 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaEVV5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <1400337445-25750-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400337445-25750-1-git-send-email-manuel.schoelling@gmx.de>
Date: Thu, 22 May 2014 23:57:44 +0200
Message-ID: <CACRpkdYJ31oTB4SJJugJU_neFgXVpVBjXs6dpYsCARJmxL=Cmg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Cleanup string initializations (char[] instead
 of char *)
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Manuel_Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 4:37 PM, Manuel Schölling
<manuel.schoelling@gmx.de> wrote:

> Initializations like 'char *foo = "bar"' will create two variables: a static
> string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> will declare a single variable and will end up in shorter
> assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
>
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

At this point of the release cycle I do not dare to apply this.

Please work in Thierry's errors and resend after the merge window.

Yours,
Linus Walleij
