Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3AQNlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:41:00 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50385 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3AQNk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:40:58 -0500
MIME-Version: 1.0
In-Reply-To: <63f2f7f3-fd03-433e-8990-d60d38954e7b@zimbra>
References: <88cea640-8f88-4fd4-9cb0-77ed482d7e19@zimbra>
	<63f2f7f3-fd03-433e-8990-d60d38954e7b@zimbra>
Date: Thu, 17 Jan 2013 14:40:58 +0100
Message-ID: <CACRpkdYRYBG9jh2h+s1RM5QtgcDNcG9pORWpX462qpNZ4FxkuQ@mail.gmail.com>
Subject: Re: [PATCH v2] lpc_ich: fix gpio base and control offsets
From: Linus Walleij <linus.walleij@linaro.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: =?ISO-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 9:42 PM, Aaron Sierra <asierra@xes-inc.com> wrote:

> In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
> offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
> properly be enabled (and disabled) for these chipsets.
>
> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
For the GPIO parts. I honestly know very little about PCI.

Yours,
Linus Walleij
