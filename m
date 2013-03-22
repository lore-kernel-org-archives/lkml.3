Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3CVTTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:19:16 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43599 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab3CVTTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:19:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Pankaj Jangra <jangra.pankaj9@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CADTbHxrF5M++Y5ku90uN7n6Jx=o80qY+dFX+B_s0udSC06D-PQ@mail.gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1363168069-11331-1-git-send-email-sachin.kamat@linaro.org>
 <CADTbHxrF5M++Y5ku90uN7n6Jx=o80qY+dFX+B_s0udSC06D-PQ@mail.gmail.com>
Message-ID: <20130322191909.834.66730@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 1/1] clk: Fix incorrect return type in clk.c
Date: Fri, 22 Mar 2013 12:19:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pankaj Jangra (2013-03-13 10:09:18)
> Hi.
> 
> On Wed, Mar 13, 2013 at 3:17 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > Return type of function clk_propagate_rate_change is a pointer.
> > But 0 was being returned. Change it to NULL.
> > Silences the following warning:
> > drivers/clk/clk.c:977:24: warning: Using plain integer as NULL pointer
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > ---
> >  drivers/clk/clk.c |    2 +-
> 
> Looks good to me.
> Reviewed-by: Pankaj Jangra <jangra.pankaj9@gmail.com>
> 

Thanks for the fix.  Taken into clk-next.

Regards,
Mike

> Regards,
> Pankaj Jangra
