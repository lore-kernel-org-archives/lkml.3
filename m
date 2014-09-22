Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaIVKwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:52:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57121 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010AbaIVKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:52:39 -0400
Date: Mon, 22 Sep 2014 11:52:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] power: twl4030-madc-battery: Convert to iio consumer.
Message-ID: <20140922105236.GH3290@leverpostej>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
 <1394052739-8589-2-git-send-email-marek@goldelico.com>
 <20140305232513.GA9542@earth.universe>
 <CAAfyv34X1naNEyht0q+bD3QUjCxLJribmfWfZkP073WS7ve4kA@mail.gmail.com>
 <CAAfyv35Hi-aE+SnTiN9O39ANi63gkNMz-Bz6hqCkkxJARSFcOg@mail.gmail.com>
 <20140814210324.GA22572@earth.universe>
 <CAAfyv36FUqCU=sdJ2izs0zMSNuSO4Q0TLg2e61AKkeDrdg_F4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv36FUqCU=sdJ2izs0zMSNuSO4Q0TLg2e61AKkeDrdg_F4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 09:13:47PM +0100, Belisko Marek wrote:
> Hi Sebastian,
> 
> On Thu, Aug 14, 2014 at 11:03 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > Hi Marek,
> >
> > On Mon, Aug 11, 2014 at 09:52:52PM +0200, Belisko Marek wrote:
> >> can you please take this series (I'll post update version with
> >> removing debug code). Thanks.
> >
> > mh. I will not pull this with "(dis)charging-calibration-data" as
> > DT property name without an ACK from the DT binding maintainers.
> DT maintainers ping.

Apologies for the delay. I will take a look at the bidning shortly.

> >
> > I would feel fine with pulling this when they are prefixed with
> > "ti,". Otherwise the series looks good to me.
> Why it should be prefixed by "ti"? Isn't enough to have "ti" prefix for driver
> compatible property? Thanks.

Because if we want to add a similar generic property, the names will
clash.

Ideally bindings should use prefixed properties by default -- those can
be replaced with generic properties as commonality becomes apparent.

Mark.
