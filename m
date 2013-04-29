Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3D2Mrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:47:42 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:57223 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab3D2Mrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:47:41 -0400
MIME-Version: 1.0
In-Reply-To: <1366995422-7135-1-git-send-email-zonque@gmail.com>
References: <1366995422-7135-1-git-send-email-zonque@gmail.com>
Date: Mon, 29 Apr 2013 14:47:41 +0200
Message-ID: <CACRpkdbSiTcRyizoViXf51PUN7MPerkzUWimAbW4k3opHo0iJw@mail.gmail.com>
Subject: Re: [PATCH, for-next] pinctrl: fix mutex deadlock in get_pinctrl_dev_from_of_node()
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Mack <zonque@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice CHOTARD <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 6:57 PM, Daniel Mack <zonque@gmail.com> wrote:

> This obvious bug was introduced by d755910b7 ("pinctrl: move subsystem
> mutex to pinctrl_dev struct").
>
> Signed-off-by: Daniel Mack <zonque@gmail.com>

Thanks, patch applied.

Yours,
Linus Walleij
