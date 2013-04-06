Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3DFIck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 04:32:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab3DFIci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 04:32:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/9] arm: mvebu: Align the internal registers virtual base to support LPAE
Date: Sat, 6 Apr 2013 10:31:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Nadav Haklai <nadavh@marvell.com>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <201304052250.28641.arnd@arndb.de> <515F3E96.4040307@free-electrons.com>
In-Reply-To: <515F3E96.4040307@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304061031.45598.arnd@arndb.de>
X-Provags-ID: V02:K0:lHJZ7s7fAQGfsr9brzyDQ4fACbCU0Kb8sOQZF+9vxS6
 xmlKmMrkpMtMkQNqfj01a0G6VVpnwpUQTkE7Z+9m63JAyxV7Vj
 fkWbViKu00WwoNxsNWAmBWBQDKFPAg8IQmsoDIX2qrcaB/vPsU
 np891uMRqYr+v3JR7sauBmnfble2aQB1GIbdG0Ls0e8WFPrTkH
 3GUdWqUDNp9jhntBBuXipLrNybX1fgwK9zGeIoJYHlKqS/ZRNO
 HB5ORwsjuKldrrurozV3Y7JitQ1Ii4LiVcJsh8T6jeDP8xoK+h
 6GcQtrfwK8deZuIW8ONDYPxBwKuTzS+HWOC26SJXVL+tzsetSA
 QeD/9zwxKaBg8JI/l0Ks=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Gregory CLEMENT wrote:
> On 04/05/2013 10:50 PM, Arnd Bergmann wrote:
> > On Friday 05 April 2013, Gregory CLEMENT wrote:
> >> From: Lior Amsalem <alior@marvell.com>
> > 
> > This is a surprising limitation. Can you extend the above text to go into more
> > detail where that alignment requirement comes from?
> > 
> 
> The explanation I had was that in LPAE section size is 2MB, in earlyprintk we map
> the internal registers and it must be section aligned.
> 

Ah, I see. Please put that in the text then.

	Arnd
