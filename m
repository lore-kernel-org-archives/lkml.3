Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbaAHRLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:11:14 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:45888 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaAHRLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:11:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1965675.1ZOPt5drrV@flatron>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Sachin Kamat" <sachin.kamat@linaro.org>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Tomasz Figa" <t.figa@samsung.com>
References: <1383963454-2749-1-git-send-email-tomasz.figa@gmail.com>
 <1965675.1ZOPt5drrV@flatron>
Message-ID: <20140108171059.27803.44729@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] MAINTAINERS: Add entry for Samsung SoC clock drivers
Date: Wed, 08 Jan 2014 09:10:59 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomasz Figa (2013-12-05 02:09:10)
> Hi,
> 
> On Saturday 09 of November 2013 03:17:34 Tomasz Figa wrote:
> > From: Tomasz Figa <t.figa@samsung.com>
> > 
> > This patch adds an entry for Samsung SoC clock drivers located under
> > drivers/clk/samsung/ directory, with me taking the maintainer role.
> > 
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Acked-by: Mike Turquette <mturquette@linaro.org>
> > Acked-by: Sachin Kamat <sachin.kamat@linaro.org>
> > Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> > ---
> >  MAINTAINERS | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 61b8757..df7e1bf 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7319,6 +7319,12 @@ L:     linux-media@vger.kernel.org
> >  S:   Supported
> >  F:   drivers/media/i2c/s5c73m3/*
> >  
> > +SAMSUNG SOC CLOCK DRIVERS
> > +M:   Tomasz Figa <t.figa@samsung.com>
> > +S:   Supported
> > +L:   linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> > +F:   drivers/clk/samsung/
> > +
> >  SERIAL DRIVERS
> >  M:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >  L:   linux-serial@vger.kernel.org
> > 
> 
> I don't see this patch applied anywhere. Mike, should it go through your
> tree?

Taken into clk-next.

Regards,
Mike

> 
> Best regards,
> Tomasz
> 
