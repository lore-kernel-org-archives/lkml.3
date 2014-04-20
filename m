Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaDTMIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:08:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50321 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbaDTMIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:08:24 -0400
Date: Sun, 20 Apr 2014 14:08:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv2 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140420120823.GB12135@amd.pavel.ucw.cz>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <1393705366-32420-1-git-send-email-sre@debian.org>
 <1393705366-32420-2-git-send-email-sre@debian.org>
 <5336A9F9.4080504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5336A9F9.4080504@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-03-29 11:09:45, Jonathan Cameron wrote:
> On 01/03/14 20:22, Sebastian Reichel wrote:
> >Update rx51-battery driver to use the new IIO API of
> >twl4030-madc and add DT support.
> >
> >Signed-off-by: Sebastian Reichel <sre@debian.org>
> This looks fine to me.  I'd love to see a more generic solution, but
> we can work on that another time.
> 
> Acked-by: Jonathan Cameron <jic23@kernel.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

I don't see this patch in 3.15-rc nor -next. What is needed to push
this patch?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
