Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbbA0HzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:55:23 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35882 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbA0HzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:55:20 -0500
MIME-Version: 1.0
In-Reply-To: <1421583604-27256-5-git-send-email-niso@kth.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se>
	<1421583604-27256-5-git-send-email-niso@kth.se>
Date: Tue, 27 Jan 2015 08:55:20 +0100
Message-ID: <CACRpkda4SBof0EaZVWtEYaeb6j_BGAVj39kje+mBz90eB3qAwQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: shmobile: emev2-kzm9d: Add PFC information
 for uart1
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niso@kth.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 1:20 PM, Niklas Söderlund <niso@kth.se> wrote:

> Configure the pinmux on kzm9d to use the serial connector for uart1.
>
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

> +&pfc {
> +       uart1_pins: uart@e1030000 {
> +               renesas,groups = "uart1_ctrl", "uart1_data";
> +               renesas,function = "uart1";
> +       };
> +};

Would be nice if the PFC driver could be augmented to also accept the
now standard bindings "groups" and "function" simply :) we're adding parse
functions for those to the core.

Yours,
Linus Walleij
