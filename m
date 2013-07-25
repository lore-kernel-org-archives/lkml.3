Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3GYPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:43:41 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34887 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3GYPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <51ED6486.3080700@broadcom.com>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
	<1374490361-25769-5-git-send-email-lee.jones@linaro.org>
	<51ED2D90.4020209@broadcom.com>
	<20130722133852.GA26801@laptop>
	<51ED3971.905@broadcom.com>
	<51ED6486.3080700@broadcom.com>
Date: Thu, 25 Jul 2013 08:43:38 -0700
Message-ID: <CAAYSxhrf+WNz1+ojA1r_pOLWg4xf9Ko8OyUc4GfVEMUN776pfA@mail.gmail.com>
Subject: Re: [PATCH 05/22] ARM: dts: bcm281xx: Remove '0x's from BCM11351 BRT
 DTS file
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <csd@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 9:57 AM, Christian Daudt <csd@broadcom.com> wrote:

> it'd be nice to have something to point
> people to as this being the best practice for kernel dev.

Power.org's ePAPR exclusively omits the 0x in the unit-address of node names.

https://www.power.org/wp-content/uploads/2012/06/Power_ePAPR_APPROVED_v1.1.pdf
