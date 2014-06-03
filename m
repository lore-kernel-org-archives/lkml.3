Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbaFCWyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:54:55 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61087 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaFCWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:54:53 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/base: Replace alias if it already exists
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <538E0144.1050700@gmail.com>
References: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
	<20140602145959.7E669C426F6@trevor.secretlab.ca>
	<538CA125.7090906@gmail.com>
	<20140603085325.490A1C4096E@trevor.secretlab.ca>
	<538D9C42.9040707@gmail.com> <538E0144.1050700@gmail.com>
Date: Tue, 03 Jun 2014 23:54:41 +0100
Message-Id: <20140603225441.0FA79C4154B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014 20:09:24 +0300, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> wrote:
> 
> 
> On  3.06.2014 12:58, Ivaylo Dimitrov wrote:
> >
> >
> > On  3.06.2014 11:53, Grant Likely wrote:
> >
> [...] Can you try putting the following into your board dts file
> >> and see if it works?
> >>
> >> aliases {
> >>     i2c0;        /* Deactivate the old alias by making it blank */
> >>     i2c1 = &i2c1;
> >>     i2c2 = &i2c2;
> >>     i2c3 = &i2c3;
> >>     i2c4 = &i2c4;
> >>     i2c5 = &i2c5;
> >> };
> >>
> >> g.
> >>
> >
> > Will do, as soon as I get back home.
> >
> > Thanks,
> > Ivo
> 
> Seems to fix the problem (tested it with qemu), will send a proper patch.

Great, I'm glad it worked.

g.

