Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaKQPMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:12:08 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46122 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaKQPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:12:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141117145651.GR24004@x1>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
	<1415708457-18798-3-git-send-email-octavian.purdila@intel.com>
	<20141113162315.GC1275@katana>
	<20141117145651.GR24004@x1>
Date: Mon, 17 Nov 2014 17:12:03 +0200
Message-ID: <CAE1zot+9-JMjKWST4VDifrjau=kXoxWB=GOHx06h8szwMwiCwg@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c: dln2: simplify return flow for dln2_i2c_enable
From: Octavian Purdila <octavian.purdila@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Johan Hovold <johan@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 4:56 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
> On Thu, 13 Nov 2014, Wolfram Sang wrote:
>
> > On Tue, Nov 11, 2014 at 02:20:57PM +0200, Octavian Purdila wrote:
> > > This fixes the following kbuild test robot warning:
> > >
> > > >> drivers/i2c/busses/i2c-dln2.c:70:1-4: WARNING: end returns can be simplified if negative or 0 value
> > >
> > > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > > Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> > >
> > > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> >
> > Acked-by: Wolfram Sang <wsa@the-dreams.de>
> >
> > Lee, I think it is easiest if you simply add it to the branch you have
> > for this driver. OK?
>
> Octavian indicated that he needs to send a v2 of the second patch.  I
> assume he will add your Ack to this patch when he does with a note
> saying that it needs to be added to the I2C IB.
>

Hi Lee,

Yes, I will to that, and add a couple more fixes from Dan Carpenter, a
little bit later tonight.
