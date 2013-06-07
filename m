Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3FGUVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:21:10 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:62975 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3FGUVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130606194616.GA4928@core.coreip.homeip.net>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
	<20130606191847.GB4542@core.coreip.homeip.net>
	<CAPDwgkPdtj0Th8P+y9e5O7swARfzS40sG1A3Ba=pAmeXfMx0Dw@mail.gmail.com>
	<20130606194616.GA4928@core.coreip.homeip.net>
Date: Fri, 7 Jun 2013 16:21:05 -0400
X-Google-Sender-Auth: vyM3IeiS-_aufbOjKC5KsW_mc6k
Message-ID: <CAPDwgkN1+y+eWnaPY599T+5RVLq7QjvOBOMdNYFrbwt6NFpDqQ@mail.gmail.com>
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v5 Daniel
 Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>, Joonyoung
 Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com, linux-input@vger.kernel.org,
 linux-kernel@vger.kernel.org, pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
From: Yufeng Shen <miletus@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Yufeng Shen <miletus@chromium.org>

Test the patch series on Chromebook Pixel with kernel 3.8.
Touchscreen & trackpad work, FW/Config update work.

On Thu, Jun 6, 2013 at 3:46 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Jun 06, 2013 at 03:40:47PM -0400, Yufeng Shen wrote:
>> On Thu, Jun 6, 2013 at 3:18 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com>wrote:
>>
>> > On Wed, Jun 05, 2013 at 06:36:53PM +0100, Nick Dyer wrote:
>> > > The following patches are an updated series of patches to the
>> > atmel_mxt_ts
>> > > touch driver. They should apply cleanly to input/next.
>> > >
>> > > This is a combined patchset, I've been working to merge my changes with
>> > the
>> > > changes from the Chromium team. It's undergone a lot of testing and
>> > review
>> > > over the last few months and I believe it is now ready to go upstream.
>> > >
>> > > Most of these changes have been maintained and tested out-of-tree in
>> > some form
>> > > for a long time. I apologise for the backlog.
>> > >
>> > > We also provide a set of user-space utilities as open source which are
>> > > available from github and work well with this driver:
>> > >   https://github.com/atmel-maxtouch/obp-utils
>> > >
>> > > You can see the in-between versions at
>> > >   https://github.com/ndyer/linux/
>> > >
>> >
>> > Daniel, Henrik,
>> >
>> > Any comments befroe I start pulling parts of this in?
>> >
>>
>>
>> Can you hold this on for a few days ?  I would like to verify this patch
>> series from chromium side.
>> I probably would do it tomorrow and next monday and send back ack asap.
>
> Sure, holding on is what I do best ;)
>
> Thanks.
>
> --
> Dmitry
