Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaDVHrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:47:18 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62865 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaDVHrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:47:15 -0400
Date: Tue, 22 Apr 2014 08:47:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Mark Brown <broonie@kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
Message-ID: <20140422074709.GD17657@lee--X1>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-6-git-send-email-dianders@chromium.org>
 <20140418174353.GX12304@sirena.org.uk>
 <CAD=FV=VQckC34rZwF2RP3F+2T1CRVs0JwtgoqUeA1NVmB20=sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=VQckC34rZwF2RP3F+2T1CRVs0JwtgoqUeA1NVmB20=sA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mark,
> 
> On Fri, Apr 18, 2014 at 10:43 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Apr 16, 2014 at 04:12:29PM -0700, Doug Anderson wrote:
> >> An issue was discovered with tps65090 where sometimes the FETs
> >> wouldn't actually turn on when requested (they would report
> >> overcurrent).  The most problematic FET was the one used for the LCD
> >
> > This is basically fine but you said it depends on one of the previous
> > patches which you didn't CC me on so I've no idea what's going on
> > there?
> 
> Sorry about that.  :(
> 
> Lee has Acked the caching patch.  Lee: what's the best way for you and
> Mark to coordinate there?  Should he apply the caching patch with your
> Ack?

If there are cross-subsystem dependencies I prefer to use immutable
branches to eliminate any change of merge conflicts in -next or the
next merge window. I'm happy to either create on with Mark's Acks, or
receive a pull-request from Mark with mine applied.

Up to Mark.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
