Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbbARTBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:01:11 -0500
Received: from mout.web.de ([212.227.17.11]:55124 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbbARTBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:01:07 -0500
Message-ID: <54BC02D2.8010008@users.sourceforge.net>
Date: Sun, 18 Jan 2015 20:00:34 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/2] PCMCIA: Deletion of a few unnecessary checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:uSog/0+dhrqzlArfkAuULkH2F+cipSldov9EPE3lCWo2QcNkyrv
 tm0zk6NIiG0X12S5Auyej63GQ6s0JjDVCgRnkr56Os5Ks7KMwgszM9eDHWXyHbw5VNsBvtm
 Evz12BNzY9twMScilkjIKKGXuVm+nILJotHMnudoyZZE7nFo7ND4fN825esqQdYizgawkNI
 aXMNWsDYQoKkMcXa5zU6Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 19:49:16 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (2):
  Deletion of checks before the function call "iounmap"
  Less function calls in bcm63xx_drv_pcmcia_probe() after error detection

 drivers/pcmcia/bcm63xx_pcmcia.c | 20 ++++++++++----------
 drivers/pcmcia/cistpl.c         |  3 +--
 drivers/pcmcia/electra_cf.c     |  6 ++----
 drivers/pcmcia/yenta_socket.c   |  3 +--
 4 files changed, 14 insertions(+), 18 deletions(-)

-- 
2.2.2

