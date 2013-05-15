Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3EOGko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:40:44 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:33377 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3EOGkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:40:43 -0400
Date: Tue, 14 May 2013 23:40:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH V2 0/5] input: pxa27x-keypad: enhancement and device tree
 support
Message-ID: <20130515064039.GA24297@core.coreip.homeip.net>
References: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
 <CADApbegCt=uGcQxdukq-svi201J+YeAX1M1vs-dKAD_AD9HFPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADApbegCt=uGcQxdukq-svi201J+YeAX1M1vs-dKAD_AD9HFPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Mon, May 13, 2013 at 04:02:07PM +0800, Chao Xie wrote:
> hi, dmitry
> What is your idea about these patches?
> Do i need add someone else to review them?
> 

No, they look good, give me a couple more days but I should apply them.
I am going to fold the first 4 into one patch though.

> On Mon, May 6, 2013 at 11:04 AM, Chao Xie <chao.xie@marvell.com> wrote:
> > The patches include 2 parts
> > 1. use matrix_keypad for matrix keyes support
> > 2. add device tree support for pxa27x-keypad
> >
> > V2->V1:
> > Do not copy the members from pdata. For device tree support,
> > directly allocate the pdata structure.
> >
> > Chao Xie (5):
> >   input: pxa27x-keypad: use matrix_keymap for matrix keyes
> >   arm: mmp: use matrix_keymap for aspenite
> >   arm: mmp: use matrix_keymap for teton_bga
> >   input: pxa27x-keypad: remove the unused members at platform data
> >   input: pxa27x-keypad: add device tree support
> >
> >  .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 +++++
> >  arch/arm/mach-mmp/aspenite.c                       |   10 +-
> >  arch/arm/mach-mmp/teton_bga.c                      |    8 +-
> >  drivers/input/keyboard/Kconfig                     |    1 +
> >  drivers/input/keyboard/pxa27x_keypad.c             |  266 ++++++++++++++++++--
> >  include/linux/platform_data/keypad-pxa27x.h        |    3 +-
> >  6 files changed, 325 insertions(+), 23 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/input/pxa27x-keypad.txt
> >
> > --
> > 1.7.4.1
> >

-- 
Dmitry
