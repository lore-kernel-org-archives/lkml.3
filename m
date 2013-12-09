Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab3LIDAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:00:04 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:63228 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259Ab3LIDAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:00:00 -0500
MIME-Version: 1.0
In-Reply-To: <2994980.boLDbkkER8@flatron>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <CAGb2v67ZNtbQm+ZW5v_3wNbz1=oLhXks6gbTSjLYa=Nnoz8w-A@mail.gmail.com>
 <20131207100737.GI24519@lukather> <2994980.boLDbkkER8@flatron>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 9 Dec 2013 10:59:38 +0800
X-Google-Sender-Auth: mQqcYUIdXM2DXJOZBuKsnckBQQg
Message-ID: <CAGb2v64BMNjbbc7j2XesuPEXZV+RnjtP1sAPQ4icU=-wjh3YNQ@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 02/10] net: stmmac: Honor DT parameter
 to force DMA store and forward mode
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: "maxime.ripard" <maxime.ripard@free-electrons.com>,
        David Miller <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>,
        "rob.herring" <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 7:06 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Saturday 07 of December 2013 11:07:37 maxime.ripard wrote:
>> On Sat, Dec 07, 2013 at 09:23:27AM +0800, Chen-Yu Tsai wrote:
>> > Point taken. The current implementation will override settings passed from
>> > platform data. ORing the two would be better.
>>
>> Platform_data and DT-based configuration are pretty unlikely to be
>> used together, so ORing it doesn't have much sense.
>
> In fact, the recommended way is to always use platform data alone if it is
> present or try to parse DT otherwise, so no mixing of data from these two
> sources should be done.

Would binding platform data with compatibles, as I did so in this patch
series, be a bad idea then?
