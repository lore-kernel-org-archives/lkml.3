Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaHKHtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:49:07 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52321 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaHKHtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <1407300196-32708-1-git-send-email-hans@hanshq.net>
References: <1407300196-32708-1-git-send-email-hans@hanshq.net>
Date: Mon, 11 Aug 2014 09:49:03 +0200
Message-ID: <CACRpkdbss=0_HJe1V5ABZ6MkKnNgKGNb-xkMbyynn7SuPqap6w@mail.gmail.com>
Subject: Re: [PATCH 09/15] pinctrl: pinctrl-at91.c: fix decimal printf format
 specifiers prefixed with 0x
From: Linus Walleij <linus.walleij@linaro.org>
To: Hans Wennborg <hans@hanshq.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 6:43 AM, Hans Wennborg <hans@hanshq.net> wrote:

> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
>
> Found by using regex suggested by Joe Perches.
>
> Signed-off-by: Hans Wennborg <hans@hanshq.net>

Patch applied with Alexandre's ACK.

Yours,
Linus Walleij
