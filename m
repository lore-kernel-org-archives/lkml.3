Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaKTIUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:20:06 -0500
Received: from mout.web.de ([212.227.15.3]:55937 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaKTIUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:20:04 -0500
Message-ID: <546DA419.7050405@users.sourceforge.net>
Date: Thu, 20 Nov 2014 09:19:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/3] [media] DVB-frontends: Deletion of a few unnecessary
 checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:kB3cy5mELBCV+6vPOcBVHpi/BoLYKXLKRf/2HVfzbxlilKiPdti
 EwvS4XO68+pK4WqXlP2uKj7HhmeVA9BpoPUVj47GVRnB5d9x0lKEO0CQDwzdS2eJwC/5Mo2
 wqO4zOjLchbERV2u7OiJcerARDAtAXRXM28kMPKTiGZCxWjZGxQIaozhFkoyG/JBJLqw8hn
 hfhnXRZY/+YIPcc5OyBQg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 23:30:37 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (3):
  DVB-frontends: Deletion of unnecessary checks before the function
    call "release_firmware"
  m88ds3103: One function call less in m88ds3103_init() after error detection
  si2168: One function call less in si2168_init() after error detection

 drivers/media/dvb-frontends/drx39xyj/drxj.c |  3 +--
 drivers/media/dvb-frontends/drxk_hard.c     |  3 +--
 drivers/media/dvb-frontends/m88ds3103.c     | 12 ++++++------
 drivers/media/dvb-frontends/si2168.c        | 10 +++++-----
 4 files changed, 13 insertions(+), 15 deletions(-)

-- 
2.1.3

