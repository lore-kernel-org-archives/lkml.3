Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162946Ab3DEUq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:46:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162046Ab3DEUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:46:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 0/9] rm: mvebu: Enable LPAE support for Armada XP SoCs
Date: Fri, 5 Apr 2013 22:46:12 +0200
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
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304052246.12731.arnd@arndb.de>
X-Provags-ID: V02:K0:lZUiu9KQDZED/xpf9KNyK1dVvvUoUFU12sFKqIB3YkO
 oDnewq4h4eHfD5S+ZqC6Glq4MYE8NuhP3EcnliqqhI6hFP2NfR
 b87loMUOcfV4GBGA4cqI8Bn+GDDqT3Ae3n7RgHMqRLLSXJVUYj
 dyh0mOO8g/hwGicI77AKDldyXc26okHsgTiwygH/DMzchMHblE
 lgnr/pCjqmJoGa+vjuYZlaMJfhlkF6A87YmrBH+2xdvka41D+J
 iFVvTq4gmJXW0Vkkegj51C6TG7glta32aUFdW9DRF0RaxHQHyw
 B4lM+vh+7kaaX8I+AzBdTT99Zazz1qGRG2K98rycEuSok9p92n
 EaXh32ZzQA47gn0xoQG4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Gregory CLEMENT wrote:
> The Armada XP SoCs have LPAE support. This is the second version patch
> set whixh allow to run kernel on this SoCs with LPAE support.
> 
> The biggest changes are the conversion of the device tree file to 64
> bits in order to be able to use more than 4GB of memory (without this
> the LPAE is pointless).
> 

The series looks good overall, I've commented on trivial details.

Also, please use "ARM: mvebu: ..." in the subject rather than the lower-case
version.

	Arnd
