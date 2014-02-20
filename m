Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaBTN3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:29:19 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56476 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaBTN3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:29:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        prabhakar.csengg@gmail.com, yongjun_wei@trendmicro.com.cn,
        sakari.ailus@iki.fi, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
Date: Thu, 20 Feb 2014 14:30:29 +0100
Message-ID: <1688708.1hcDfqTyU5@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53060055.2010408@free-electrons.com>
References: <CA+V-a8tn54CcaFEBMM48GMnTuG=OhQtxm7=od_4OZm6Xo_S9qA@mail.gmail.com> <4210530.AR5GZgidVz@avalon> <53060055.2010408@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thursday 20 February 2014 14:17:09 Michael Opdenacker wrote:
> On 02/20/2014 12:36 PM, Laurent Pinchart wrote:
> > Hi Michael,
> > 
> > What's the status of this patch ? Do expect Prabhakar to pick it up, or do
> > you plan to push all your IRQF_DISABLED removal patches in one go ?
> 
> It's true a good number of my patches haven't been picked up yet, even
> after multiple resends.

Maintainers might have assumed that you would push all the patches yourself. 
That might be why Prabhakar has acked your patch but hasn't picked it up.

> I was planning to ask the community tomorrow about what to do to finally
> get rid of IRQF_DISABLED. Effectively, pushing all the remaining changes
> in one go (or removing the definition of IRQF_DISABLED) may be the final
> solution.
> 
> I hope to be able to answer your question by the end of the week.
> 
> Thanks for getting back to me about this!

-- 
Regards,

Laurent Pinchart

