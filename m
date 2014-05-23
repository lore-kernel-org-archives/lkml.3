Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaEWN6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:58:35 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41881 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaEWN6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:58:34 -0400
MIME-Version: 1.0
In-Reply-To: <1400685297-30754-1-git-send-email-iivanov@mm-sol.com>
References: <1400685297-30754-1-git-send-email-iivanov@mm-sol.com>
Date: Fri, 23 May 2014 15:58:33 +0200
Message-ID: <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Enable "power-source" to be extracted from DT files
From: Linus Walleij <linus.walleij@linaro.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 5:14 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Add "power-source" property to generic options used for DT parsing files.
> This  enables drivers, which use generic pin configurations, to get the
> value passed to this property.
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Great! But please also patch:
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

In this same patch to add the binding, and respin.

Yours,
Linus Walleij
