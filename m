Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaGHFHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:07:51 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:50581 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbaGHFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:07:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMbAGx7u1NXQzVo/2dsb2JhbABZgw5SgXeBAak/AQEBAQEBBQFukhGHQAICAYEXF3WEAwEBAQMBAQI3HCMFCwgDDgouIQcRHgYTiC4DCQwBCMMKDYV9F4VwhwqCKAeEQwEEmApsgX8BgUiKBIIshhSDRTs
Date: Tue, 8 Jul 2014 07:08:08 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        open list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: imx: use PTR_ERR_OR_ZERO
Message-Id: <20140708070808.07c7f690e82c9bcf822f772e@skynet.be>
In-Reply-To: <CAK5sBcE2xxb1NGegn1L_CFH27vzx8kLg06u9fVTo6SZk8_6qJQ@mail.gmail.com>
References: <1404500590-21712-1-git-send-email-fabf@skynet.be>
	<20140707055521.GM30239@dragon>
	<CAK5sBcE2xxb1NGegn1L_CFH27vzx8kLg06u9fVTo6SZk8_6qJQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014 09:18:56 +0530
Sachin Kamat <spk.linux@gmail.com> wrote:

> Hi Shawn,
> 
> On Mon, Jul 7, 2014 at 11:25 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > On Fri, Jul 04, 2014 at 09:03:10PM +0200, Fabian Frederick wrote:
> >> replace IS_ERR/PTR_ERR
> >>
> >> Cc: Shawn Guo <shawn.guo@freescale.com>
> >> Cc: Sascha Hauer <kernel@pengutronix.de>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> >
> > Applied, thanks.
> 
> 
> I had sent a similar series [1] in May which you rejected. Just
> curious if something
> changed between then and now?

Hi Sachin,

	I still don't see anything from you for those files in linux-next lately.
If it was already in some other tree, you can remove my patch or update signed-off-by as it seems
you made it before me :)
 
Regards,
Fabian

> 
> [1] http://patchwork.ozlabs.org/patch/353653/
> 
> -- 
> Regards,
> Sachin.
