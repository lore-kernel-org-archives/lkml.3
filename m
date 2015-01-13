Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbbAMGXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:23:23 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:52769 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbAMGXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:23:21 -0500
MIME-Version: 1.0
In-Reply-To: <1418414497-23741-1-git-send-email-niso@kth.se>
References: <1418414497-23741-1-git-send-email-niso@kth.se>
Date: Tue, 13 Jan 2015 07:23:20 +0100
Message-ID: <CACRpkdbzS3At9bYDzrZRhz8ac_qM49-BB56=+F=4Q9Uo89pANQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] sh-pfc: Add emev2 pinmux support
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niso@kth.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 9:01 PM, Niklas Söderlund <niso@kth.se> wrote:

> Greetings,
>
> This patchset introduces pinmux support for the EMMA Mobile EV2 board to
> the sh-pfc pin-controller driver. Devicetree bindings for gpio and the
> populated serial connector are also defined in 3/4 and 4/4.
>
> Comments are welcome!

I'm waiting for the maintainer (Laurent's) comments.

Yours,
Linus Walleij
