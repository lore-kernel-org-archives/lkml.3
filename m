Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbaD2JXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:23:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50517 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbaD2JXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:23:36 -0400
Date: Tue, 29 Apr 2014 11:23:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/5] Input: add common DT binding for touchscreens
Message-ID: <20140429092334.GC19146@xo-6d-61-c0.localdomain>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
 <1398470179-20880-2-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398470179-20880-2-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-04-26 01:56:15, Sebastian Reichel wrote:
> Add common DT binding documentation for touchscreen devices and
> implement input_parse_touchscreen_of_params, which parses the common
> properties and configures the input device accordingly.
> 
> The method currently does not interpret the axis inversion properties,
> since there is no matching flag in the generic linux input device.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
