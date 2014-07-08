Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaGHGTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:19:12 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:52838 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaGHGTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140708051916.GB26257@dragon>
References: <1404500590-21712-1-git-send-email-fabf@skynet.be>
	<20140707055521.GM30239@dragon>
	<CAK5sBcE2xxb1NGegn1L_CFH27vzx8kLg06u9fVTo6SZk8_6qJQ@mail.gmail.com>
	<20140708051916.GB26257@dragon>
Date: Tue, 8 Jul 2014 11:49:09 +0530
Message-ID: <CAK5sBcEfL2oXBW+fiNwMeTxeBckmxtjQL52+-OXwj2nrMvhy4A@mail.gmail.com>
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

On Tue, Jul 8, 2014 at 10:49 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Tue, Jul 08, 2014 at 09:18:56AM +0530, Sachin Kamat wrote:
>> Hi Shawn,
>>
>> On Mon, Jul 7, 2014 at 11:25 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>> > On Fri, Jul 04, 2014 at 09:03:10PM +0200, Fabian Frederick wrote:
>> >> replace IS_ERR/PTR_ERR
>> >>
>> >> Cc: Shawn Guo <shawn.guo@freescale.com>
>> >> Cc: Sascha Hauer <kernel@pengutronix.de>
>> >> Cc: linux-arm-kernel@lists.infradead.org
>> >> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>> >
>> > Applied, thanks.
>>
>>
>> I had sent a similar series [1] in May which you rejected. Just
>> curious if something
>> changed between then and now?
>
> The main difference is this is the second attempt from a different
> person to "clean up" the code.  I'm still not fond of the change, but
> I'm getting tied to tell people about that, so just applied the change,
> since after all it at least gives some good diffstat.
>
> I would prefer Fabian's patch over yours because it's really good
> enough to have one patch than 5 patches in a series to do the change for
> IMX platform.

Doesn't really matter whose patches are in. I was just curious to know
the change
in logic at this point of time. Thanks for clarification.

-- 
Regards,
Sachin.
