Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaHYPuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:50:10 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49272 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbaHYPuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:50:08 -0400
MIME-Version: 1.0
In-Reply-To: <4584014.Iu24cpYxxY@phil>
References: <1408725508-24066-1-git-send-email-dianders@chromium.org>
	<4584014.Iu24cpYxxY@phil>
Date: Mon, 25 Aug 2014 08:50:07 -0700
X-Google-Sender-Auth: uc5bs5gBjzSBrMnJZtOFx8LC7MY
Message-ID: <CAD=FV=XH4wj-3vCobd_D5F1-Ef_jrLm-=hv8MknUBcYVLg5Jzg@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: Fix the clocks for i2c1 and i2c2
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
>
>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Reported-by: Addy Ke <addy.ke@rock-chips.com>
>
> The error-case we discussed yesterday was quite clear, so
>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Just in case anyone reading was wondering: I've now received a new
version of the TRM (technical reference manual) the confirms the
correctness of this patch.

Mike: maybe you could apply it to 3.17 fixups?

-Doug
