Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaD1TME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:12:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56082 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaD1TL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:11:58 -0400
Date: Mon, 28 Apr 2014 19:56:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jenny Tc <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC] power_supply: Introduce generic psy charging driver
Message-ID: <20140428175606.GA26042@amd.pavel.ucw.cz>
References: <1396843810-16743-1-git-send-email-jenny.tc@intel.com>
 <20140428165436.GA23310@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428165436.GA23310@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-04-28 22:24:36, Jenny Tc wrote:
> Dmitry/Pavel,
> 
> Request your feedback on this. Fixed the comments from Pavel and waiting for 
> your feedback on the changes

IIRC, my latest comments were "this is completely misdesigned, it is
using strings and table searches where it should use pointers". Did
that change?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
