Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaJAHpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:45:50 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52696 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaJAHps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:45:48 -0400
MIME-Version: 1.0
In-Reply-To: <1412086542-1662-2-git-send-email-pramod.gurav@smartplayin.com>
References: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
	<1412086542-1662-2-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 1 Oct 2014 09:45:48 +0200
Message-ID: <CACRpkdZVyxN+W_8s3Hvij0wu=bE-tyAFhJPVKumRvDkpUDuncA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: remove use of gpiochip_remove() retval
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 4:15 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> Get rid of using return value from gpiochip_remove() as it returns
> void.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> CC: Lee Jones <lee.jones@linaro.org>
> Cc: linux-gpio@vger.kernel.org
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Already fixed in the GPIO tree.

Yours,
Linus Walleij
