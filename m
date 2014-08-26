Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbaHZNTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:19:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42554 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaHZNTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:19:13 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        rabin@rab.in, Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v7 0/8] Per-user clock constraints
Date: Tue, 26 Aug 2014 15:20:54 +0200
Message-ID: <5035317.536XV5BeWG@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomeu,

Am Montag, 18. August 2014, 17:30:26 schrieb Tomeu Vizoso:
> Hi,
> 
> in this v7 of the patchset I have only rebased on top of 3.17rc1, with no
> other changes. I have had to do a fair amount of fixing due to the rebase,
> more details below. Follows the original cover letter blurb:
> 
> I'm retaking Rabin's patches [0] for splitting the clk API in two: one API
> for clk consumers and another for providers. The consumer API uses a clk
> structure that just keeps track of the consumer and has a reference to the
> actual clk_core struct, which is used internally.
> 
> I have kept a patch from Rabin that aims to aid in debugging nested
> enable/disable calls, though my personal aim is to allow more than one
> consumer to influence the final, effective frequency rate. For now this is
> limited to setting floor and ceiling constraints, with the short-term aim
> of allowing devfreq and thermal drivers to set floor and ceiling
> frequencies on the memory clock, respectively.

sounds interesting. I've tested your clk-refactoring-7 branch on a Rockchip 
rk3188-radxarock and rk3288-evb-rk808 board, so

Tested-by: Heiko Stuebner <heiko@sntech.de>


Heiko

