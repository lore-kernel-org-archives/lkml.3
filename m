Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaBXKIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:08:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59290 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBXKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:08:38 -0500
MIME-Version: 1.0
In-Reply-To: <1393165274-32492-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-6-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 24 Feb 2014 11:08:37 +0100
Message-ID: <CACRpkdaUAEQ9twMRzND423AcGVCG0_iPy6MG2O6GFbguB-RV7Q@mail.gmail.com>
Subject: Re: [PATCH v4 05/16] pinctrl: mvebu: add common mpp reg helper to
 mvebu pinctrl include
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 3:21 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This adds some defines and helper functions for the common mpp reg
> layout to mvebu pinctrl include.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> ---
> Changelog:
> v3->v4:
> - add helper functions provided by Thomas Petazzoni

Patch applied. I like the looks of these helpers.

Yours,
Linus Walleij
