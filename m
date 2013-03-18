Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3CRPXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:23:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52650 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3CRPXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:23:40 -0400
Message-ID: <51473179.2030306@wwwdotorg.org>
Date: Mon, 18 Mar 2013 09:23:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
CC: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the tegra tree with the arm-soc tree
References: <20130318153140.100bdf364d5614ce31f12eae@canb.auug.org.au>
In-Reply-To: <20130318153140.100bdf364d5614ce31f12eae@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 10:31 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tegra tree got a conflict in 
> drivers/clocksource/tegra20_timer.c between commit 1d16cfb3aeba 
> ("clocksource: tegra20: use the device_node pointer passed to
> init") from the arm-soc tree and commit 6f88fb8af6c6 ("clocksource:
> tegra: move to of_clk_get") from the tegra tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action is required).

Thanks. This resolution looks fine.

Arnd/Olof, do you want me to rebase the Tegra branch onto some arm-soc
branch to resolve this conflict, or are you happy to simply resolve it
as below when pulling the Tegra branches into arm-soc for 3.10?
