Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3KLChy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:37:54 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55332 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3KLChN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:37:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/5] OF: Introduce utility helper functions
To: Guenter Roeck <linux@roeck-us.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <527A57D9.3070402@roeck-us.net>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-6-git-send-email-panto@antoniou-consulting.com> <527A0A12.2050803@nsn.com> <57092A71-2C68-4B92-A748-5D0DE69EC141@antoniou-consulting.com> <527A57D9.3070402@roeck-us.net>
Date: Mon, 11 Nov 2013 16:12:54 +0000
Message-Id: <20131111161254.B85BDC4231C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013 06:53:13 -0800, Guenter Roeck <linux@roeck-us.net> wrote:
> Hi Pantelis,
> 
> On 11/06/2013 01:34 AM, Pantelis Antoniou wrote:
> 
> >
> > As I mentioned earlier I'm trying to get this accepted in general term and then we'll
> > get around fixing any minor problems.
> >
> 
> I think it is quite likely at this point that your series will be accepted.
> 
> However, from my experience with larger submissions like this one, it is quite common
> that the maintainers ask for all feedback to be addressed before that happens -
> especially for feedback like this, where there is common understanding that some
> changes to the code are necessary.
> 
> Maybe the device tree maintainers could chime in at this point and let us all know
> what will need to happen to get the series accepted.

Since it is a big series, I would like to be able to "front-load" the
series of changes with straighforward changes that are easy to merge.
There are some exceptions though, such as when new APIs with users later
in the series. I don't really want to pull in a new API separately from
the user most of the time.

g.

