Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaHaWSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 18:18:16 -0400
Received: from doppler.thel33t.co.uk ([193.110.88.198]:41419 "EHLO
	doppler.thel33t.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHaWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 18:18:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 31 Aug 2014 23:30:10 +0100
From: Leigh Brown <leigh@solinno.co.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Simon Boulay <simon.boulay@vitec.com>,
        Arnaud Ebalard <arno@natisbad.org>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Raphael Rigo <ml-arm@syscall.eu>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/4] clk: mvebu: Fix clk frequency value if SSCG is
 enabled
In-Reply-To: <d9e3be49b00eb7dd8827f05a955b4497@doppler.thel33t.co.uk>
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
 <1409312620-20631-2-git-send-email-gregory.clement@free-electrons.com>
 <d9e3be49b00eb7dd8827f05a955b4497@doppler.thel33t.co.uk>
Message-ID: <ba70e97da698fe6053adbb6218c905a3@doppler.thel33t.co.uk>
User-Agent: Roundcube Webmail/1.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-31 23:25, Leigh Brown wrote:
[...]
> /* NB: 0.96% = 0.0048 or 3/625 */
> freq_swing_half = (((u64)high_bound - (u64)low_bound)
> 		* (u64)system_clk * 3);
> do_div(freq_swing_half, (625 * high_bound));

Sigh.  The comment should be:

/* NB: half of 0.96% is 0.0048 or 3/625 */

The code should be right :-)

Regards,

Leigh.

