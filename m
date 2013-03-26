Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab3CZOQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:16:34 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:32940 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab3CZOQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <2667057.bEM8NUnrg3@avalon>
References: <20130326002301.10878.32801.sendpatchset@w520>
	<2667057.bEM8NUnrg3@avalon>
Date: Tue, 26 Mar 2013 23:16:30 +0900
Message-ID: <CANqRtoTtJMELH4R9ekAKdaACeqg2vr3mKCqCFKUcdbsq5dqJPA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver V3
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Mar 26, 2013 at 10:03 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thanks for the patch.
>
> On Tuesday 26 March 2013 09:23:01 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch is V3 of a GPIO driver for the R-Car series of
>> SoCs from Renesas. This driver is designed to be reusable
>> between multiple SoCs that share the same basic building block,
>> but so far it has only been used on R-Car H1 (r8a7779).

>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> I've taken the patch in my tree.

That's great, thanks!

/ magnus
