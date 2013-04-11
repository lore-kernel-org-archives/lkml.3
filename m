Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3DLAFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 20:05:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58046 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3DLAFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 20:05:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18a2udmQGffrnlbB2XklUI+jpPnMCkInwA=
Date: Thu, 11 Apr 2013 19:29:30 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        Ike Pan <ike.pan@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/9] ARM: mvebu: Enable pj4b on LPAE compilations
Message-ID: <20130411232930.GQ28693@titan.lakedaemon.net>
References: <1365461538-30702-1-git-send-email-gregory.clement@free-electrons.com>
 <1365461538-30702-5-git-send-email-gregory.clement@free-electrons.com>
 <20130411180844.GO28693@titan.lakedaemon.net>
 <51671FFE.1010909@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51671FFE.1010909@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:41:34PM +0200, Gregory CLEMENT wrote:
> Hi Jason,
> 
> On 04/11/2013 08:08 PM, Jason Cooper wrote:
> > On Tue, Apr 09, 2013 at 12:52:12AM +0200, Gregory CLEMENT wrote:
> >> From: Lior Amsalem <alior@marvell.com>
> >>
> >> pj4b cpus are LPAE capable so enable them on LPAE compilations
> >>
> >> Signed-off-by: Lior Amsalem <alior@marvell.com>
> >> Tested-by: Franklin <flin@marvell.com>
> >> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> >> ---
> >>  arch/arm/mm/proc-v7.S |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Applied to mvebu/soc
> > 
...
> 
> However, this one should go through Russell's git tree.  Or at least
> you need his acked-by. I have already submit this patch on Russell
> patch system. Unfortunately Russell told that he will be away for
> around one week.
> 
> This patch is needed to have LPAE support, but all the other patches
> don't depend on it. That means that if you applied all the other
> patches it won't break anything even if at the end this patch is not
> merged. But I really hope that Russell will be able to apply this
> patch to his git tree.

ok, thanks for catching this before I sent the PR.  I'll drop it.

thx,

Jason.
