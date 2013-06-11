Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3FKIuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:50:07 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36391 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3FKIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <51B619B9.8040204@wwwdotorg.org>
References: <201306090159.05383.heiko@sntech.de>
	<201306090201.17739.heiko@sntech.de>
	<CACRpkdaEcZZ3NZzwKOhUPjvFg+bSZ=UbpyPT2EBcAfVv1-EsKA@mail.gmail.com>
	<51B619B9.8040204@wwwdotorg.org>
Date: Tue, 11 Jun 2013 10:50:04 +0200
Message-ID: <CACRpkdYT08w-3KuMD9YLcjebcpbqyOpWdqH5NU+fjAeP6VpkWQ@mail.gmail.com>
Subject: Re: [EXAMPLE PATCH] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patrice Chotard <patrice.chotard.st@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 8:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> The entire reason I created the <dt-bindings/> directory (rather than
> just putting *.h into e.g. arch/arm/boot/dts) was to provide a place to
> share binding-defined constants between the DT files and drivers that
> implement that binding. It's certainly my opinion that if/when *.dts
> move out of the kernel, the <dt-bindings/> directory should continue to
> be present in the kernel, and take updates mirrored from the upstream
> binding repo.

OK thanks Stephen, makes perfect sense.

Yours,
Linus Walleij
