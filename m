Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbaIRUNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:13:51 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:55169 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaIRUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:13:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140814210324.GA22572@earth.universe>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
	<1394052739-8589-2-git-send-email-marek@goldelico.com>
	<20140305232513.GA9542@earth.universe>
	<CAAfyv34X1naNEyht0q+bD3QUjCxLJribmfWfZkP073WS7ve4kA@mail.gmail.com>
	<CAAfyv35Hi-aE+SnTiN9O39ANi63gkNMz-Bz6hqCkkxJARSFcOg@mail.gmail.com>
	<20140814210324.GA22572@earth.universe>
Date: Thu, 18 Sep 2014 22:13:47 +0200
Message-ID: <CAAfyv36FUqCU=sdJ2izs0zMSNuSO4Q0TLg2e61AKkeDrdg_F4Q@mail.gmail.com>
Subject: Re: [PATCH v2] power: twl4030-madc-battery: Convert to iio consumer.
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Thu, Aug 14, 2014 at 11:03 PM, Sebastian Reichel <sre@kernel.org> wrote:
> Hi Marek,
>
> On Mon, Aug 11, 2014 at 09:52:52PM +0200, Belisko Marek wrote:
>> can you please take this series (I'll post update version with
>> removing debug code). Thanks.
>
> mh. I will not pull this with "(dis)charging-calibration-data" as
> DT property name without an ACK from the DT binding maintainers.
DT maintainers ping.
>
> I would feel fine with pulling this when they are prefixed with
> "ti,". Otherwise the series looks good to me.
Why it should be prefixed by "ti"? Isn't enough to have "ti" prefix for driver
compatible property? Thanks.
>
> -- Sebastian

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
