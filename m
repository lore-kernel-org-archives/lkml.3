Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaIIW4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:56:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36903 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaIIW4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:56:13 -0400
MIME-Version: 1.0
In-Reply-To: <1410003731-32276-1-git-send-email-broonie@kernel.org>
References: <1410003731-32276-1-git-send-email-broonie@kernel.org>
Date: Wed, 10 Sep 2014 00:56:12 +0200
Message-ID: <CA+gwMceBMs2hpiPhjJoj6N+BFgDN_26YeB6CXqFeY6OMQ4jmoQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: isl9305: Add Intersil ISL9305/H driver
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Sep 6, 2014 at 1:42 PM, Mark Brown <broonie@kernel.org> wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/regulator/isl9305.txt b/Documentation/devicetree/bindings/regulator/isl9305.txt
> new file mode 100644
> index 000000000000..a626fc1bbf0d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/isl9305.txt
> @@ -0,0 +1,36 @@
> +Intersil ISL9305/ISL9305H voltage regulator
> +
> +Required properties:
> +
> +- compatible: "isl,isl9305" or "isl,isl9305h"

I have suggested to change the Intersil vendor prefix to 'isil':
http://www.mail-archive.com/devicetree@vger.kernel.org/msg40842.html

regards
Philipp
