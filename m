Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaIJCuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:50:20 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43358 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaIJCuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140909223952.GL2601@sirena.org.uk>
References: <20140908183350.5a4e357c@canb.auug.org.au>
	<20140909223952.GL2601@sirena.org.uk>
Date: Tue, 9 Sep 2014 19:50:18 -0700
X-Google-Sender-Auth: 502gc0SUOP83eJIeuEW0NJ-rkmc
Message-ID: <CAD=FV=UwnNLJ+11sz73RqrNJa4n5yKUHzjZyQ4HpN_9MQ-2iuA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zhong <zyw@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 9, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Sep 08, 2014 at 06:33:50PM +1000, Stephen Rothwell wrote:
>
>> drivers/regulator/rk808-regulator.c:312:18: warning: 'struct rk808_board' declared inside parameter list
>>            struct rk808_board *pdata)
>
> Chris, as previously requested please send me any changes needed to
> update for the changes in the MFD driver.

See <https://patchwork.kernel.org/patch/4873501/>

-Doug
