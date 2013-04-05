Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422666Ab3DEUpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162046Ab3DEUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:45:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 8/9] arm: dts: mvebu: fix cpus section indentation
Date: Fri, 5 Apr 2013 22:45:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <1365193444-13441-9-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1365193444-13441-9-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304052245.07775.arnd@arndb.de>
X-Provags-ID: V02:K0:poSHQ18doiUsNiYl8qFFnEqagrCRAOiRMCQ6sD3JTYb
 joW5I3Kf79QdoJwssvs5D+mj3qdc2a1k7mPRK24yDoCn0NpTJ9
 ScMHrQ3K+ygCVsaMybVW6+MJvjncpI43cgXZKUC7umZLXyEfAo
 PJef5J6KMLzyNLb3lyQ9sxXiJAwTc1tcaLQSLcO1gfw23G6YC7
 5T9KusWEwLUZ4MQQ4EfZdb0UDE/nlg8oCujOP8HTC5WaCBQh9I
 +uMevPVHOutGR7X1QCCK79FTbiuI7+YGh2rMNkuv1JUui/AygT
 lGqn/MFFkyrLB17tK6Ig8BH0DyxD+TiDraQ+7ctBA0S9TYtj9E
 6XTr+Le0bd6bJu+c4/dQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Gregory CLEMENT wrote:
> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

This should have a description, even though it's completely trivial.
I would also recommend moving this patch first, as the general rule
is to do cleanups first.

	Arnd
