Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaGHDs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:48:59 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:39669 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGHDs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:48:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140707055521.GM30239@dragon>
References: <1404500590-21712-1-git-send-email-fabf@skynet.be>
	<20140707055521.GM30239@dragon>
Date: Tue, 8 Jul 2014 09:18:56 +0530
Message-ID: <CAK5sBcE2xxb1NGegn1L_CFH27vzx8kLg06u9fVTo6SZk8_6qJQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: imx: use PTR_ERR_OR_ZERO
From: Sachin Kamat <spk.linux@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        open list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Mon, Jul 7, 2014 at 11:25 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Fri, Jul 04, 2014 at 09:03:10PM +0200, Fabian Frederick wrote:
>> replace IS_ERR/PTR_ERR
>>
>> Cc: Shawn Guo <shawn.guo@freescale.com>
>> Cc: Sascha Hauer <kernel@pengutronix.de>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> Applied, thanks.


I had sent a similar series [1] in May which you rejected. Just
curious if something
changed between then and now?

[1] http://patchwork.ozlabs.org/patch/353653/

-- 
Regards,
Sachin.
