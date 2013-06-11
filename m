Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3FKIst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:48:49 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59134 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3FKIss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <201306102140.29918.heiko@sntech.de>
References: <201306102139.32444.heiko@sntech.de>
	<201306102140.29918.heiko@sntech.de>
Date: Tue, 11 Jun 2013 10:48:47 +0200
Message-ID: <CACRpkdbEkP-UbwsMD7bDokDU_Swa4_mCQcxu+Z7AeUfdYZ8xaw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig
 properties from a dt node
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 9:40 PM, Heiko Stübner <heiko@sntech.de> wrote:

> pinconf_generic_parse_dt_config() takes a node as input and generates an
> array of generic pinconfig values from the properties of this node.
>
> As I couldn't find a mechanism to count the number of properties of a node
> the function uses internally an array to accept one of parameter and copies
> the real present options to a smaller variable at its end.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Looks good, patch applied!

> +Supported configuration parameters are:
> +
> +bias-disable           - disable any pin bias
> +bias-high-impedance    - high impedance mode ("third-state", "floating")
(...)

We should probably document applicable arguments to these,
and indicate which ones are boolean. But that can be fixed up
later.

Yours,
Linus Walleij
