Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaHUHKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:10:31 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37613 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaHUHK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140821021200.GB11103@lunn.ch>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com> <20140821021200.GB11103@lunn.ch>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 21 Aug 2014 09:10:08 +0200
X-Google-Sender-Auth: cRYxHTps8ovJbdPoLSaQQ0vgxrY
Message-ID: <CAAObsKBUiNu-be2AvjedqoPrFNSTdcSA7nGg4PWisJR1Ry_gwA@mail.gmail.com>
Subject: Re: [PATCH v7 0/8] Per-user clock constraints
To: Andrew Lunn <andrew@lunn.ch>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        rabin@rab.in, Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2014 04:12, Andrew Lunn <andrew@lunn.ch> wrote:
> On Mon, Aug 18, 2014 at 05:30:26PM +0200, Tomeu Vizoso wrote:
>> Hi,
>>
>> in this v7 of the patchset I have only rebased on top of 3.17rc1, with no other
>> changes. I have had to do a fair amount of fixing due to the rebase, more
>> details below. Follows the original cover letter blurb:
>
> Hi Tomeu
>
> I would like to test this patchset, but patch 5 never made it to the
> list. Do you have a git tree i can clone?

Sure:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=clk-refactoring-7

Though it seems to have made into at least one mailing list (the
others seem to have rejected it because of either its size, or the
number of recipients):

http://article.gmane.org/gmane.linux.ports.ppc64.devel/104392

Thanks for the interest!

Tomeu

> Thanks
>         Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
