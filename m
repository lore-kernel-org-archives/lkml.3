Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3FMPSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:18:04 -0400
Received: from www.xora.org.uk ([80.68.91.202]:39626 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FMPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:18:02 -0400
Date: Thu, 13 Jun 2013 11:32:42 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        balbi@ti.com, peter.ujfalusi@ti.com, t-kristo@ti.com, tony@atomide.com
Subject: Re: [RFC v1] MFD: Change TWL6025 references to TWL6032
Message-ID: <20130613103242.GA5456@mint>
References: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com>
 <20130607143649.GS31367@sirena.org.uk>
 <c73c260b90be6e1640a430e8cbba6cac@slimlogic.co.uk>
 <51B99D0D.4050603@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B99D0D.4050603@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 01:21:01PM +0300, Oleksandr Kozaruk wrote:
> On 06/07/2013 05:44 PM, gg@slimlogic.co.uk wrote:
> >On 2013-06-07 15:36, Mark Brown wrote:
> >>On Fri, Jun 07, 2013 at 01:53:10PM +0300, Oleksandr Kozaruk wrote:
> >>>From: Graeme Gregory <gg@slimlogic.co.uk>
> >>>
> >>>The TWL6025 was never released beyond sample form and was replaced by
> >>>the PhoenixLite range of chips - TWL6032. Change the references to
> >>>reference the TWL6032 class and name the registers to twl6032
> >>>in line with
> >>>an actual released chip name to avoid confusion.
> >>>
> >>>Currently there is no users of TWL6025 in the code.
> >>
> >>Given that the chip exists even if not widely distributed it seems as
> >>well to keep the twl6025 references in there at least in the device ID
> >>table - it won't do any harm to people using the twl6032 name and might
> >>help someone who happens to pick up an old board for whatever reason.
> >
> >I do not think any "old boards" exist, it really was a limited run!
> >
> >Graeme
> >
> Hello Mark, Graeme,
> 
> Taking in account that:
> - there is no hardware to test twl6025, testing is not possible;
> - there is no documentation for twl6025, and if there are any
> changes to twl6032 is not known;
> - twl6032 is available, and in production, twl6025 is not even found
> on ti.com <http://ti.com>
> 
> So, what do you think, can this change be accepted?
> 
> // I apologize for sending personal e-mails, not to the mail list

I have never seen a twl6025 board, it only ever existed AFAIK in lab samples
which were used on a generic carrier board. twl6032 was the actual production
device.

Graeme

