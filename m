Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbbAIJsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:48:35 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:64521 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbbAIJsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:48:33 -0500
MIME-Version: 1.0
In-Reply-To: <1419196495-9626-16-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
	<1419196495-9626-16-git-send-email-wsa@the-dreams.de>
Date: Fri, 9 Jan 2015 10:48:31 +0100
Message-ID: <CACRpkdajZWaJzirP=qeSGZMjn2kB4MZCPzH30r=WP4CLFYoDkQ@mail.gmail.com>
Subject: Re: [PATCH 15/28] pinctrl: intel: drop owner assignment from platform_drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:14 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Patch applied.

Yours,
Linus Walleij
