Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaCZAmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:42:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24660 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaCZAmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:42:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wV9XqAC/tSeFFFaH1kXJTAo/+LRpVX9M=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8591754C137
Date: Tue, 25 Mar 2014 20:42:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/14] CPU idle for Armada XP
Message-ID: <20140326004223.GL28304@titan.lakedaemon.net>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory,

On Tue, Mar 25, 2014 at 11:48:11PM +0100, Gregory CLEMENT wrote:
...
> The first patch should go through ARM subsystem and should be taken by
> Russell King. I made few change on it following Lorenzo advice and
> now it will reuse the cpu v7 suspend and resume function and just do
> specific operation before calling them.
> 
> The 13th patch 'cpuidle: mvebu: Add initial cpu idle support for
> Armada 370/XP SoC' is the only one who should go to the cpuidle
> subsystem. But of course I would like that Daniel Lezcano or Rafael
> J. Wysocki have a look on the whole series and especially patches 10,
> 12 and 14.

Ok, I'm tired.  :)  Help me out here.  Patches 1 and 13 are depended on
by the other patches and vice-versa, right?  In that case, I'm thinking
it's best to seek Acks from the other maintainers and keep the whole
branch together.  Please tell me if I'm wrong.

thx,

Jason.
