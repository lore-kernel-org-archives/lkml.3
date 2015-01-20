Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbbATRkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:40:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42794 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbbATRkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:40:13 -0500
Date: Tue, 20 Jan 2015 18:40:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robherring2@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        sakari.ailus@iki.fi, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
Message-ID: <20150120174010.GA2900@amd>
References: <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <54B4DA81.7060900@samsung.com>
 <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
 <54B8D4D0.3000904@samsung.com>
 <CAL_Jsq+EFWzs1HP1tVt6P=p=HZn2AtSPjp55YrmMQi_mE+kNfQ@mail.gmail.com>
 <54B933D0.1090004@samsung.com>
 <54BE7DAB.80702@samsung.com>
 <CAL_JsqKoiaUmVhbQdnNveG=AAYh4-OHGS70L+LAgLLoKChUuYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKoiaUmVhbQdnNveG=AAYh4-OHGS70L+LAgLLoKChUuYQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-20 11:29:16, Rob Herring wrote:
> On Tue, Jan 20, 2015 at 10:09 AM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
> > On 01/16/2015 04:52 PM, Jacek Anaszewski wrote:
> >>
> >> On 01/16/2015 02:48 PM, Rob Herring wrote:
> 
> [...]
> 
> >>> You may want to add something like led-output-cnt or led-driver-cnt in
> >>> the parent so you know the max list size.
> >>
> >>
> >> Why should we need this? The number of current outputs exposed by the
> >> device is fixed and can be specified in a LED device bindings
> >> documentation.
> >>
> >
> > OK. The led-output-cnt property should be put in each sub-node, as the
> > number of the current outputs each LED can be connected to is variable.
> 
> Sorry, I meant this for the parent node meaning how many outputs the
> driver IC has. I did say maybe because you may always know this. It
> can make it easier to allocate memory for led-sources knowing the max
> size up front.

Umm. Not sure if that kind of "help" should go to the device
tree.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
