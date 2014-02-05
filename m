Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaBEKDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:03:35 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:56453 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaBEKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <1391463780-19840-1-git-send-email-markus.mayer@linaro.org>
References: <1391463780-19840-1-git-send-email-markus.mayer@linaro.org>
Date: Wed, 5 Feb 2014 11:03:32 +0100
Message-ID: <CACRpkda=h=0bpMfHeq-zJs5nZ+740rz9jZChCk0OAHm=Jmw5AQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: bcm281xx: Update MODULE_AUTHOR
From: Linus Walleij <linus.walleij@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 10:43 PM, Markus Mayer <markus.mayer@linaro.org> wrote:

> Add Broadcom's upstreaming mailing list address to MODULE_AUTHOR.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>

Hm OK not that this is used very much, and nothing to argue about
so patch applied.

However we do not really recognize corporate bodies as maintainers,
only physical people whose GPG keys we can sign ... but I
guess you wanted to convey that the driver is the work of several
individuals inside BRCM and thus authors, while you take care
of the maintenance.

A patch to MAINTAINERS adding this to Christians entry for
the SoCs or as a standalone entry with Markus as maintainer
would be more important and usefule than this though, so I'm
throwing out that challenge!

Yours,
Linus Walleij
