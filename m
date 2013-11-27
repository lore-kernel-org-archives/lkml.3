Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3K0LBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:01:30 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:48624 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3K0LB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:01:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Nov 2013 12:05:03 +0100
From: Stefan Agner <stefan@agner.ch>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de, mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
In-Reply-To: <1385546387.4270.11.camel@weser.hi.pengutronix.de>
References: <cover.1385508112.git.stefan@agner.ch>
 <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
 <1385546387.4270.11.camel@weser.hi.pengutronix.de>
Message-ID: <6311b14be5af09d82e6781160e2aac3a@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,

Am 2013-11-27 10:59, schrieb Lucas Stach:
> This isn't a global Tegra change, but very specific to the Colibri, so
> please reword your commit headline to reflect that.
Agree, will do that.

> Also there are other issues with the regulator setup on Colibri, I sent
> a patch for this a good while ago, but didn't come around to revise it
> until now. So if you are going to touch things here, please look up that
> patch and fold it into this one.
I guess you refer to this patchset:
http://thread.gmane.org/gmane.linux.ports.tegra/11984

Ok, I will fold patch 4 into my patchset. Not sure whether I should add
patch 3 (ULPI phy on Colibri T20) as well, since this one is somewhat
unrelated...

> I'll take a look at the other patches later today.
Thanks

--
Stefan
