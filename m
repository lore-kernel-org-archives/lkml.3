Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbbASLO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:14:28 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:56476 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbASLOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:14:24 -0500
From: Robert Rosengren <robert.rosengren@axis.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
CC: Johan Adolfsson <johana@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2015 12:14:21 +0100
Subject: SV: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval
 configurable
Thread-Topic: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval
 configurable
Thread-Index: AdAxuoFRNnMlH38xSi+kuHC8bBPsWQCHcffW
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D059418DD4823@xmail3.se.axis.com>
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
 <54B92596.2040206@roeck-us.net>,<20150116183020.GA6262@roeck-us.net>
In-Reply-To: <20150116183020.GA6262@roeck-us.net>
Accept-Language: sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, Jan 16, 2015 at 06:52:06AM -0800, Guenter Roeck wrote:
> > I am basically fine with the patch, though I would prefer replacing
> > the entire update handling and chip access with regmap. Would you be
> > interested in doing that ?
> >
> I sent a couple of patches a minute ago which should take care of the issue.
> Would be great if you can test it.
>
> Thanks,
> Guenter

OK, great. I will look into your patch next week, since I'm currently out of office.

BR, 
Robert