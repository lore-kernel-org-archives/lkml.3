Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3LGLGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 06:06:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54004 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3LGLGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 06:06:10 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: "maxime.ripard" <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, David Miller <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        "rob.herring" <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 02/10] net: stmmac: Honor DT parameter to force DMA store and forward mode
Date: Sat, 07 Dec 2013 12:06:03 +0100
Message-ID: <2994980.boLDbkkER8@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20131207100737.GI24519@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org> <CAGb2v67ZNtbQm+ZW5v_3wNbz1=oLhXks6gbTSjLYa=Nnoz8w-A@mail.gmail.com> <20131207100737.GI24519@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 of December 2013 11:07:37 maxime.ripard wrote:
> On Sat, Dec 07, 2013 at 09:23:27AM +0800, Chen-Yu Tsai wrote:
> > Point taken. The current implementation will override settings passed from
> > platform data. ORing the two would be better.
> 
> Platform_data and DT-based configuration are pretty unlikely to be
> used together, so ORing it doesn't have much sense.

In fact, the recommended way is to always use platform data alone if it is
present or try to parse DT otherwise, so no mixing of data from these two
sources should be done.

Best regards,
Tomasz

