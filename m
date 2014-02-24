Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaBXFb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:31:58 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48903 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaBXFb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:31:56 -0500
MIME-Version: 1.0
In-Reply-To: <53060055.2010408@free-electrons.com>
References: <CA+V-a8tn54CcaFEBMM48GMnTuG=OhQtxm7=od_4OZm6Xo_S9qA@mail.gmail.com>
 <1386584182-5400-1-git-send-email-michael.opdenacker@free-electrons.com>
 <4210530.AR5GZgidVz@avalon> <53060055.2010408@free-electrons.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 24 Feb 2014 11:01:35 +0530
Message-ID: <CA+V-a8s2RFiqENVk2mR4dQ92ZhvB93BcyMLy0cX3eZkns5HRaQ@mail.gmail.com>
Subject: Re: [PATCH][RESEND] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, Feb 20, 2014 at 6:47 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> Hi Laurent,
>
> On 02/20/2014 12:36 PM, Laurent Pinchart wrote:
>> Hi Michael,
>>
>> What's the status of this patch ? Do expect Prabhakar to pick it up, or do you
>> plan to push all your IRQF_DISABLED removal patches in one go ?
> It's true a good number of my patches haven't been picked up yet, even
> after multiple resends.
>
> I was planning to ask the community tomorrow about what to do to finally
> get rid of IRQF_DISABLED. Effectively, pushing all the remaining changes
> in one go (or removing the definition of IRQF_DISABLED) may be the final
> solution.
>
> I hope to be able to answer your question by the end of the week.
>
gentle ping. should I pick it up ?

Regards,
--Prabhakar Lad
