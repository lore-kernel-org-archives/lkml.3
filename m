Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3DPPTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:19:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752396Ab3DPPTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:19:23 -0400
Message-ID: <1366125562.18313.9.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Update Grant's email address and
 maintainership
From: Joe Perches <joe@perches.com>
To: grant.likely@linaro.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Date: Tue, 16 Apr 2013 08:19:22 -0700
In-Reply-To: <1366109016-27442-1-git-send-email-grant.likely@linaro.org>
References: <1366109016-27442-1-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-16 at 11:43 +0100, grant.likely@linaro.org wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> It has also been many years
> since I've touched any of the Xilinx related code so mark those items as
> unmaintained.

Hi Grant.

Please use "Orphan" as described in MAINTAINERS instead.
get_maintainers.pl doesn't understand "Unmaintained".

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -4806,11 +4806,8 @@ F:	arch/powerpc/platforms/40x/
[]
>  LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
> -M:	Grant Likely <grant.likely@secretlab.ca>
> -W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
>  L:	linuxppc-dev@lists.ozlabs.org
> -T:	git git://git.secretlab.ca/git/linux-2.6.git
> -S:	Maintained
> +S:	Unmaintained
[]
> @@ -8942,9 +8938,7 @@ S:	Maintained
[]
>  XILINX SYSTEMACE DRIVER
> -M:	Grant Likely <grant.likely@secretlab.ca>
> -W:	http://www.secretlab.ca/
> -S:	Maintained
> +S:	Unmaintained


