Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3HGUBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:01:35 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62561 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab3HGUBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <1375809032-21477-2-git-send-email-swarren@wwwdotorg.org>
References: <1375809032-21477-1-git-send-email-swarren@wwwdotorg.org>
	<1375809032-21477-2-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 7 Aug 2013 22:01:33 +0200
Message-ID: <CACRpkdaSbndjDki=CgKhm_ATsUYExOUzcNRrVnhp+-GaDV3c=w@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] pinctrl: add generic pins and functions properties
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 7:10 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> pinctrl bindings can benefit from generic property names that define
> which pins a "pin configuration node" affects, and which mux function
> to select onto those pins. Document new properties for this purpose so
> that other bindings may refer to them.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Define the arguments that the pins and functions properties take.

Patch applied.

Yours,
Linus Walleij
