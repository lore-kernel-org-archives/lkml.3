Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3AUK5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:57:07 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61058 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3AUK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:57:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130121104946.GA27252@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-13-git-send-email-thierry.reding@avionic-design.de>
	<CAOh2x==ECCN-2wEkFuNQ6DN2K6LMe3kvYMXXpk1bzQvUVo19Wg@mail.gmail.com>
	<20130121104946.GA27252@avionic-0098.adnet.avionic-design.de>
Date: Mon, 21 Jan 2013 16:27:03 +0530
Message-ID: <CAKohpomN3tzdyHpv4ms2kgMK2DAQ9Q-8554He-1LjkVF0iXr_Q@mail.gmail.com>
Subject: Re: [PATCH 12/33] Input: Convert to devm_ioremap_resource()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2013 16:19, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> Can you specify why? devm_request_and_ioremap() and the new
> devm_ioremap_resource() both already output an error message if they
> can't request or ioremap the memory region, so all this does is output a
> duplicate error message.

because i missed implementations of these routines.. Ignore this comment
wherever i gave it :)
