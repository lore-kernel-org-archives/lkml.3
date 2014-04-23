Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaDWOJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:09:08 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49070 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaDWOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:09:05 -0400
MIME-Version: 1.0
In-Reply-To: <1398180483-10651-1-git-send-email-phil.edworthy@renesas.com>
References: <1398180483-10651-1-git-send-email-phil.edworthy@renesas.com>
Date: Wed, 23 Apr 2014 16:09:04 +0200
Message-ID: <CACRpkdYy_fGfm-mj122aqAELBBew1Af0Q=OHP0KWxkeg1uGbyw@mail.gmail.com>
Subject: Re: [PATCH] sh-pfc: r8a7790: Fix definition of IPSR5
From: Linus Walleij <linus.walleij@linaro.org>
To: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Guido Piasenza <gpiasenza@soft-in.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-SH <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 5:28 PM, Phil Edworthy
<phil.edworthy@renesas.com> wrote:

> From: Guido Piasenza <gpiasenza@soft-in.com>
>
> The extra entry in the table makes SCIFA0_B, and all peripherals after it, fail.
>
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>

Patch applied for fixes with Lauren's additional fixup moving the define one
line up.

Yours,
Linus Walleij
