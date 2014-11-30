Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaK3UVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:21:45 -0500
Received: from mout.web.de ([212.227.17.11]:51779 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaK3UVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:21:44 -0500
Message-ID: <547B7C36.1070600@users.sourceforge.net>
Date: Sun, 30 Nov 2014 21:21:10 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/2] [media] tuners: Deletion of two unnecessary checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ttK8wEea6FsQUc+rhdSy0kWzBBcnwet54M3LC5T1Wdq/Z+chNKB
 C00m8esvY0D674NX2RtAcHuzcndZS3VW6WLzgxjEzebvxYb3S/y0LZ/Sxa9FE3fBRprDiZi
 QQm5rpNms1jKi9BFoveG0bNh9KJWtgnW8aKhnij5qIFtp8E3Ugn+3pzggZtzWh7v5tHy6Tn
 nF8vHniwYfPb5qmETyyGA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 20:50:15 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (2):
  Deletion of unnecessary checks before the function call "release_firmware"
  One function call less in si2157_init() after error detection

 drivers/media/tuners/si2157.c | 9 ++++-----
 drivers/media/tuners/xc5000.c | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.1.3

