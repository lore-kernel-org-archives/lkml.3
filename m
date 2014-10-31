Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbaJaVLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:11:05 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64486 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaJaVLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <1414660895-29255-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1414660895-29255-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 31 Oct 2014 22:11:02 +0100
Message-ID: <CACRpkdYOM5LBUSq1GXL2ruODROtULHNdpO57zhspDYTs_13H3g@mail.gmail.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: check return of devm_ioremap for error
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:21 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> Error check around return value of devm_ioremap is missing. Add the same
> to avoid NULL pointer dereference.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
