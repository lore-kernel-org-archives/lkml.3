Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3IMJ3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:29:51 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43094 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3IMJ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <1379061913-17604-1-git-send-email-chauplac@gmail.com>
References: <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com>
	<1379061913-17604-1-git-send-email-chauplac@gmail.com>
Date: Fri, 13 Sep 2013 11:29:48 +0200
Message-ID: <CACRpkdbra_X7x=hdeVaoAe2vJndSUS_Cu7__tUnKUAwCV5wpDA@mail.gmail.com>
Subject: Re: [PATCH] scripts/config: fix variable substitution command
From: Linus Walleij <linus.walleij@linaro.org>
To: Clement Chauplannaz <chauplac@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:45 AM, Clement Chauplannaz
<chauplac@gmail.com> wrote:

> Commit 229455bc02b87f7128f190c4491b4ceffff38648 accidentally changed the
> separator between sed `s' command and its parameters from ':' to '/'.
>
> Revert this change.
>
> Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>

This patch fixes my issue with --set-str, thanks!

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
