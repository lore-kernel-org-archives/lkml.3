Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaIXKlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:41:06 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:40559 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIXKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140924064124.GS15315@lukather>
References: <1411311493-24344-1-git-send-email-wens@csie.org> <20140924064124.GS15315@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 24 Sep 2014 18:40:42 +0800
X-Google-Sender-Auth: MDhDDXT5mRd-I416tuinddoJ6Wg
Message-ID: <CAGb2v659fps1WAqkdnbnTtHxAdCZQy+rYXDC90Y44pPtcxnsFg@mail.gmail.com>
Subject: Re: [PATCH 0/6] ARM: sunxi: Add basic support for Allwinner A80 SoC
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl <ctl@merrii.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 24, 2014 at 2:41 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Chen-Yu,
>
> On Sun, Sep 21, 2014 at 10:58:07PM +0800, Chen-Yu Tsai wrote:
>> Hi everyone,
>>
>> This patch series adds very basic support for Allwinner's A80 SoC,
>> a big.LITTLE architecture with 4 Cortex-A7s and 4 Cortex-A15s.
>>
>> Development is done on the A80 Optimus Board, the defacto development
>> board for the A80, with the accompanying SDK as a reference.
>>
>> So far I've been unable to get the board to boot from MMC, or
>> using Android fastboot. I'm using Allwinner's FEL mode to load
>> the bootloader and kernel+dtb image over USB. Notes on my attempts
>> can be found here: http://linux-sunxi.org/User:Wens#A80_Optimus
>
> It looks very nice, thanks a lot. You'll find a minor comments inline.
>
> One thing I forgot to ask you about when doing the A23, and that would
> nice to do is to update the documentation we have in
> Documentation/arm/sunxi/README with the A23 and A80 infos you've been
> able to gather.

I'll add the A80 datasheet in v2, and do a separate series for A23, A31,
and A31s docs.


Thanks
ChenYu
