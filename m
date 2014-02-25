Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaBYXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:00:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaBYXA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:00:28 -0500
Message-ID: <530D2087.1020407@wwwdotorg.org>
Date: Tue, 25 Feb 2014 16:00:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
CC: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCHv2 1/5] ARM: tegra: remove obsolete gpio entries
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com> <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 05:22 AM, Heikki Krogerus wrote:
> After moving to description based gpio interface in
> rfkill-gpio, the gpio numbers are not used any more.

Acked-by: Stephen Warren <swarren@nvidia.com>

This shouldn't cause any conflicts since I really don't anticipate
changing board-paz00.c in this kernel cycle other than this patch.

If you want though, I can prepare a branch and signed tag in the Tegra
tree, containing this patch, and you can merge it. I'm fine either way.
