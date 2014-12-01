Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbaLAWa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:30:57 -0500
Received: from mout.web.de ([212.227.17.11]:63099 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbaLAWay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:30:54 -0500
Message-ID: <547CEBF5.4040004@users.sourceforge.net>
Date: Mon, 01 Dec 2014 23:30:13 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/2] [media] mn88473: Delete an unnecessary check
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:d+lTDORBidZh1MoR3jV1z+3WT+Nog2LiLG9Y1G5gb/GsYOOFHTw
 IGU/Z8hRlgQrKkpmyBzcFjh2lQfD1wcXnRCRpqIwVUzyTAw1BEjCwi0zzK9vY3Zr8X6CP7b
 4LKPmdTXbaTNGh3KiSY7MRLVjy16VK81Z/MlY5Vrfp4byPoNihch1zFtOOWMT+29QGhALhf
 ryrEbE/52HK54UY9/4Gzw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 23:16:34 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (2):
  Deletion of an unnecessary check before the function call "release_firmware"
  One function call less in mn88473_init() after error detection

 drivers/staging/media/mn88473/mn88473.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.1.3

