Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaK3Qkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:40:52 -0500
Received: from mout.web.de ([212.227.15.4]:54673 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaK3Qku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:40:50 -0500
Message-ID: <547B4886.4080406@users.sourceforge.net>
Date: Sun, 30 Nov 2014 17:40:38 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/3] net-PPP: Deletion of a few unnecessary checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ziLeTTf7J3VHO5maAsaVXolk9I4V8MG0JDYt2jR6zJCW3L38lw/
 ov/fb2Yp9oPVfS+8bIcdJDGsmLgEYNce/k3TkrS1+i1yBvT20EdxgCioBIk9bZbcqbWzzg/
 /cZhB4Uptdl1wQx6IU8iv3Zy9EZuggKaIzadr9EGoJCAUFKxCw1RWP3PVhGO8WN3FOFi39Q
 hvgnijsHBlxsajH5Z6AGg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 17:25:40 +0100

Further update suggestions were taken into account after a patch was applied
from static source code analysis.

Markus Elfring (3):
  Deletion of unnecessary checks before the function call "kfree"
  Less function calls in mppe_alloc() after error detection
  Delete an unnecessary assignment

 drivers/net/ppp/ppp_mppe.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

-- 
2.1.3

