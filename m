Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161661Ab3DKSI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:08:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55981 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847Ab3DKSIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:08:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+aMMArjO3rwTwaJqqfJYrG1TdQ81QjEfQ=
Date: Thu, 11 Apr 2013 14:08:10 -0400
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
Subject: Re: [PATCH v3 3/9] ARM: mvebu: Align the internal registers
 virtual base to support LPAE
Message-ID: <20130411180810.GN28693@titan.lakedaemon.net>
References: <1365461538-30702-1-git-send-email-gregory.clement@free-electrons.com>
 <1365461538-30702-4-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365461538-30702-4-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:52:11AM +0200, Gregory CLEMENT wrote:
> From: Lior Amsalem <alior@marvell.com>
> 
> In order to be able to support the LPAE, the internal registers
> virtual base must be aligned to 2MB. In LPAE section size is 2MB, in
> earlyprintk we map the internal registers and it must be section
> aligned.
> 
> Signed-off-by: Lior Amsalem <alior@marvell.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/include/debug/mvebu.S      |    2 +-
>  arch/arm/mach-mvebu/armada-370-xp.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied to mvebu/soc

thx,

Jason.
