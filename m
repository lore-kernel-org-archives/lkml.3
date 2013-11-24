Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3KXVca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 16:32:30 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33665 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3KXVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 16:32:24 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <monstr@monstr.eu>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <CAEgOgz5BWzo-LGddjG6ZUtKt6GHxLmDUEndFOdVrn+1HTPvpGQ@mail.gmail.com>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> < 1381869563-16083-10-git-send-email-grant.likely@linaro.org> < CAEgOgz6=HhBkb2KtxcmHpNdE_0sNngw0NaL2SnLWj1opZkO3SA@mail.gmail.com> < 20131112065405.C75E8C42024@trevor.secretlab.ca> < CAEgOgz6j8YsvFgq8ZbE20ocHPA0C-eUGBb7F1gNiVBvJXLa8_g@mail.gmail.com> < 20131112085038.B6A75C421BB@trevor.secretlab.ca> < CAEgOgz4dM1zQdFpOkUwZqAUMUBe2eh3j1Ah0KgomVAOGgrPsVw@mail.gmail.com> < 20131113061425.667F9C41807@trevor.secretlab.ca> < CAEgOgz5BWzo-LGddjG6ZUtKt6GHxLmDUEndFOdVrn+1HTPvpGQ@mail.gmail.com>
Date: Sun, 24 Nov 2013 21:32:12 +0000
Message-Id: <20131124213212.226B8C402C3@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Nov 2013 17:04:52 +1000, Peter Crosthwaite <peter.crosthwaite@xilinx.com> wrote:
> On Wed, Nov 13, 2013 at 4:14 PM, Grant Likely <grant.likely@linaro.org> wrote:
> > On Wed, 13 Nov 2013 09:17:01 +1000, Peter Crosthwaite <peter.crosthwaite@xilinx.com> wrote:
> >> It's going to get a little verbose once you start making multiple
> >> connections as you need one mux per wire. Perhaps it could be cleaned
> >> up by making the foo_irq_mux node(s) a child of foo?
> >
> > It could, but then you need some way of attaching a driver to that node,
> > and that would require building knowledge into the driver again.
> >
> > Can you boil it down to a couple of concrete examples? What is a
> > specific example of how the platform should decide which interrupt line
> > to use?
> >
> 
> So i've spent some time playing with this. I now have a booting kernel
> with multiple root interrupt controllers and peripheral devices
> multiply-connected to both root controllers. But only one on of the
> controllers is used by Linux (as linux being able to use multiple
> intcs is a non-trivial problem). So the scheme I am using is to have
> one of these root intc's marked as disabled via

Multiple intc's should be a solved problem. What issue are you seeing?
Or is this a microblaze specific problem?

> Working with Michal to get my patches in a list-ready state. Can you
> suggest a candidate tree we should base of for contributions to
> drivers/of/irq.c given your recent work?

Linux-next. It is always linux-next.  :-)

g.

