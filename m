Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab3GLKyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:54:22 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:39326 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3GLKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130705195512.GJ27646@sirena.org.uk>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
	<20130705195512.GJ27646@sirena.org.uk>
Date: Fri, 12 Jul 2013 13:54:20 +0300
Message-ID: <CAHp75VeasHGariq=v005NSUTe_+e471NYbEoSzPJXcFNgsfKNQ@mail.gmail.com>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Bin Gao <bin.gao@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 5, 2013 at 10:55 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 06, 2013 at 11:33:46AM -0700, Bin Gao wrote:
>
>> A good example is that an ISP(Imaging Signal Processor) driver needs
>> register i2c camera sensor devices via v4l2, so it has to unregister
>> all i2c clients that were previously registered by calling
>> i2c_register_board_info(), and then re-register. For this case we
>> can use this helper to get i2c_client by passing the client name.
>
> Please look at the work that IIRC Laurent Pichart (CCed) was doing on
> developing generic DT bindings for v4l in embedded systems,

I couldn't find anything related to OF except v4l2-of.c in the v4l2-core.
Is that what you mentioned?

> it sounds
> like you're working on similar hardware here.  The general ideas should
> apply to any enumeration mechanism, not just DT.

Briefly looking into ACPI tables we have and mechanisms that we can
use in ACPI case, I doubt we may apply all the ideas, probably some of
them, though I didn't get yet where to read about in details. What I
could say now is that the patch provided by Bin Gao is definitely no
go.

--
With Best Regards,
Andy Shevchenko
