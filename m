Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FXOhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:37:06 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60925 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3FXOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <1371047735-14851-2-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1371047735-14851-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<1371047735-14851-2-git-send-email-gabriel.fernandez.st@gmail.com>
Date: Mon, 24 Jun 2013 16:37:03 +0200
Message-ID: <CACRpkdZdVY3HzcFh=XYmFMWUp9hjzK2usiXCKvQov+6AZnG4CQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: u8540: DT: Set pinctrl mapping to i2c0,1,2,4 & 5
From: Linus Walleij <linus.walleij@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 4:35 PM, Gabriel Fernandez
<gabriel.fernandez.st@gmail.com> wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
>
> This patch configures pin map in device tree of i2c0,
> 1,2,4 & 5 for ccu8540 board.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>

Patch applied to my ux500-devicetree branch.

Yours,
Linus Walleij
