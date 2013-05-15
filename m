Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3EOIp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:45:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51708 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3EOIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com>
References: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com>
Date: Wed, 15 May 2013 10:45:55 +0200
Message-ID: <CACRpkdYiTtKYE900YYQDPer5GZacYunC9OkAiff4vSM67m73aw@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: vt8500: use devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 4:59 PM, Laurent Navet <laurent.navet@gmail.com> wrote:

> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
>
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_ioremap_resource.cocci
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Patch applied with Tony's ACK.

Thanks!
Linus Walleij
