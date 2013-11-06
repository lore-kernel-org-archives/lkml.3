Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3KFUl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:41:57 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54109 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346Ab3KFUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:41:54 -0500
Date: Wed, 6 Nov 2013 21:41:43 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Message-ID: <20131106204143.GD8662@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <C10E33D7-53F6-4A50-9B84-1149DDBDC46F@antoniou-consulting.com>
 <20131106203102.GB8662@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106203102.GB8662@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.11.13, Sebastian Andrzej Siewior wrote:
> > It has been discussed.
> > 
> > We are doing it because

Please don't get me wrong. I am not against this, I am just curious why
this needs to be done at runtime and bootloader time is not an option.

Sebastian
