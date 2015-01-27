Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbbA0HtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:49:00 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64730 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbbA0Hs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:48:57 -0500
MIME-Version: 1.0
In-Reply-To: <1421583604-27256-2-git-send-email-niso@kth.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se>
	<1421583604-27256-2-git-send-email-niso@kth.se>
Date: Tue, 27 Jan 2015 08:48:56 +0100
Message-ID: <CACRpkdbwyyN8qY8LuowbWtyz7JZg8Ki3Rrg0g0J6xQ5Px5MUoQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] sh-pfc: add macro to define pinmux without function
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

> Used to define pinmux configurations where the pinmux function have no
> representation in the configuration registers but instead solely depends
> on a group selection.
>
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Patch applied with Laurent's ACK.

Yours,
Linus Walleij
