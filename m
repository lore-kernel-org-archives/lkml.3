Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbaGaMtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:49:20 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42344 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaGaMtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:49:18 -0400
Message-ID: <53DA3B45.4080501@gmail.com>
Date: Thu, 31 Jul 2014 14:49:09 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: devicetree@vger.kernel.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>, linux-doc@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/5] clk: samsung: exynos5410: Organize register offset
 constants
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-3-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1406805732-17372-3-git-send-email-hsnaves@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Humberto,

Please see my comments inline.

On 31.07.2014 13:22, Humberto Silva Naves wrote:
> The different register groups (SRC, DIV, PLL, GATE, etc) are
> now separated by a blank line, and within the same group, the
> definitions are ordered by address. This is done to reduce the
> chances of potential conflicts when adding new entries, and
> to improve the readability of code. While at it, replaced some
> spaces with tabs to keep consistency.

I'm not sure whether this change really improves anything.

It might seem plausible to have the registers grouped by their purpose,
however remaining drivers have them directly listed in order of their
addresses to match the order they are mentioned in documentation. For
consistency, I'd prefer only one convention to be used across all
Samsung clock drivers, so they would have to be changed as well. But
IMHO this is a material for a separate clean-up series, while this one
should be limited to functional improvements.

In fact, this driver is kind of exception as it has PLL register
definitions separated, which I probably missed in review.

Best regards,
Tomasz
