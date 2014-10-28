Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaJ1UNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:13:40 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58187 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJ1UNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:13:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Scott Branden <sbranden@broadcom.com>, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Antti Palosaari <crope@iki.fi>,
        bcm-kernel-feedback-list@broadcom.com, Alex Elder <elder@linaro.org>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Ray Jui <rjui@broadcom.com>, Matt Porter <mporter@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Daudt <bcm@fixthebug.org>, linux-kernel@vger.kernel.org,
        JD Zheng <jdzheng@broadcom.com>, Kumar Gala <galak@codeaurora.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v8 8/8] ARM: multi_v7_defconfig: Enable Broadcom Cygnus
Date: Tue, 28 Oct 2014 21:13:20 +0100
Message-ID: <1982026.E1VTksgscj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <544FF744.5020707@broadcom.com>
References: <1414525992-3678-9-git-send-email-sbranden@broadcom.com> <5089697.D8odgNlVtY@wuerfel> <544FF744.5020707@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:J3CL0zwv9/3CppFS7DUMOPO1T2jsIFbLoLigbBKOaYz
 O22MKBDM5qNwZB/lpcULOBW16rtmRq4clIZ62t4v252p4edY7v
 uTX2rWpyl75rKfT3rUI3cCDLFf11RFKy2OIFiK9YxgpLf+M/h9
 aHcnV5OPLEHwJZ8VFKptd/XuiyoIV9GeNDd9S5DjcdNoS5k2iM
 w1tFYULnm+kYucb9IC4m+/rG8PhcZZ033GGXg8Mw7YlFZXZLd9
 UZXyW4lOMSprS7KnqkD0ejZiUhmpcIE6NsyXgWw/pK7leIIsVR
 X0QlssQn9j/sXt+ybsXlDH/q9tzWzfAV8ZpnzTUqHKSK4g5kTj
 t2SqjEyrfkWMwrY1yxyE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 13:06:28 Scott Branden wrote:
> On 14-10-28 01:01 PM, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 12:53:12 Scott Branden wrote:
> >> From: Ray Jui <rjui@broadcom.com>
> >>
> >> Enable Broadcom Cygnus platform support in multi_v7_defconfig
> >>
> >> Signed-off-by: Ray Jui <rjui@broadcom.com>
> >> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> >>
> >
> > Just to be sure: did you check that multi_v7_defconfig contains
> > all the drivers you need that you enable in your other defconfig?
> No - the other defconfig has more that have not been tested on the 
> device.  The defconfig builds, but the other drivers haven't been 
> tested.  I guess we can try adding them to the multi_defconfig right now 
> as well or wait until we have tested them?  There will need to be 
> addition dts changes in the future after we have tested the other drivers.
> 
> Can we wait to add them to multi_v7_defconfig or do you want them in 
> this patchset?

The important part is that you don't break other platforms, and that
is independent of whether the code actually does the right thing.

If you know that you will need certain drivers to make use of
the platform, just enable them now.

	Arnd
