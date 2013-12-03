Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3LCMQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:16:46 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37560 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3LCMQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:16:44 -0500
MIME-Version: 1.0
In-Reply-To: <001d01ceefb3$733b8cb0$59b2a610$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<001d01ceefb3$733b8cb0$59b2a610$%han@samsung.com>
Date: Tue, 3 Dec 2013 13:16:43 +0100
Message-ID: <CACRpkdYBiSSgpSvJAARK5uUwNqqVTNc_iqVs3=SXg4FWfoa1xw@mail.gmail.com>
Subject: Re: [PATCH 08/39] gpio: remove DEFINE_PCI_DEVICE_TABLE macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 12:08 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied to the GPIO tree.

Yours,
Linus Walleij
