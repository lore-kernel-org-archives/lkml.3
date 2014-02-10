Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaBJSgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:36:42 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:41618 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaBJSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:36:36 -0500
Message-ID: <52F91C31.8060509@codethink.co.uk>
Date: Mon, 10 Feb 2014 18:36:33 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
References: <1392037257-20607-1-git-send-email-geert+renesas@linux-m68k.org>
In-Reply-To: <1392037257-20607-1-git-send-email-geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/14 13:00, Geert Uytterhoeven wrote:
> A QSPI function set consists of 3 groups:
>    - qspi_ctrl (2 control wires)
>    - qspi_data2 (2 data wires, for Single/Dual SPI)
>    - qspi_data4 (4 data wires, for Quad SPI)

Hi, do you have a branch with all your SPI/QSPI work on that we
could have a test with please?


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
