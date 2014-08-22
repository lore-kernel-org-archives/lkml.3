Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaHVQsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:48:22 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63572 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaHVQsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <4584014.Iu24cpYxxY@phil>
References: <1408725508-24066-1-git-send-email-dianders@chromium.org>
	<4584014.Iu24cpYxxY@phil>
Date: Fri, 22 Aug 2014 09:48:20 -0700
X-Google-Sender-Auth: yGn2GxJ2kD4EXpHnsPCD-HUFaCU
Message-ID: <CAD=FV=UmpdzkUDwQyNCRf+N0a-_hn3Hpkr_wwddTJc6Y8x9vfQ@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: Fix the clocks for i2c1 and i2c2
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Fri, Aug 22, 2014 at 9:46 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Freitag, 22. August 2014, 09:38:28 schrieb Doug Anderson:
>> The clocks for i2c1 and i2c2 are flipped.  The clock tree matched the
>> Technical Reference Manual (TRM) but the TRM was wrong.  Swap them in
>> the clock tree.  This was determined experimentally (by Addy) and
>> confirmed by the Rockchip IC team.
>>
>> Seires-cc: Eddie Cai <eddie.cai@rock-chips.com>
>
> I guess this is a typo...

Doh, let me repost just to make it clear.  Sorry about that!  :(
