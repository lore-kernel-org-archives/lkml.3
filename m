Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaBWTTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:19:40 -0500
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:48246 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751241AbaBWTTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:19:38 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Feb 2014 14:19:38 EST
Message-ID: <530A477C.6070007@codethink.co.uk>
Date: Sun, 23 Feb 2014 19:09:48 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: vladimir.barinov@cogentembedded.com
CC: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, magnus.damm@gmail.com, horms@verge.net.au,
        gnurou@gmail.com, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH] gpio: gpio-rcar: init at postcore level
References: <1393173467-12240-1-git-send-email-vladimir.barinov@cogentembedded.com>
In-Reply-To: <1393173467-12240-1-git-send-email-vladimir.barinov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/14 16:37, vladimir.barinov@cogentembedded.com wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> This adds ability to use gpio API at board init_machine level.
>
> F.e. it can be used in the following situation.
> Many reference hardware has onboard switches that selects which periferals
> to connect to the system. The gpio input state from switches can be used
> in choosing platform devices runtime in board code instead of ifdefs/defconfig
> changes.

Firstly, anyone still using platform_devices to describe their
system needs to be stopped. We cannot go on supporting this when
our primary boot method is supposed to be device-tree. If we keep
doing this then we will not get any of the current issues fixed.

Will it impact the devicetree bindings on rcar?


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
