Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaDWOK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:10:29 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59771 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaDWOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <1398184685-31670-1-git-send-email-phil.edworthy@renesas.com>
References: <1398184685-31670-1-git-send-email-phil.edworthy@renesas.com>
Date: Wed, 23 Apr 2014 16:10:27 +0200
Message-ID: <CACRpkdZrvvkuGJ0u_eqUP5pD7mHZRHiEq2LwNUnGWyZLxrZVRA@mail.gmail.com>
Subject: Re: [PATCH] sh-pfc: r8a7791: Fix definition of MOD_SEL3
From: Linus Walleij <linus.walleij@linaro.org>
To: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-SH <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 6:38 PM, Phil Edworthy
<phil.edworthy@renesas.com> wrote:

> There is a missing 0 entry from the MOD_SEL3 table.
>
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>

Patch applied for fixes with Laurent's ACK.

Yours,
Linus Walleij
