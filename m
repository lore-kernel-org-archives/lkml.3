Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaKWSeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:34:25 -0500
Received: from mout.web.de ([212.227.15.4]:55095 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaKWSeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:34:23 -0500
Message-ID: <54722893.6020301@users.sourceforge.net>
Date: Sun, 23 Nov 2014 19:33:55 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/2] staging: android: ion: Deletion of a few unnecessary
 checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:8/v0dVhlmyw7IrFT57m0aYrgVLgnhjsMw7CJVQc+tjFKSoFstVA
 ZFdH4wm46yN3ltnTDehEO4qG5wXjM4/qi3bCOH53u42CoqdOeGfQR4pfkwM7z+DvwpmH07s
 fQBA516/jeEUXu4+vbv3ndAfGwIFCjgFtW3KPfjq1z6X/7XC395aYVQYJZVLSjcrrG0HURl
 g7ZipciW/SmtnQUJSF8XA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 19:13:56 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (2):
  Deletion of unnecessary checks before two function calls
  One function call less in ion_buffer_create() after error detection

 drivers/staging/android/ion/ion.c              | 9 +++------
 drivers/staging/android/ion/ion_dummy_driver.c | 6 ++----
 drivers/staging/android/ion/tegra/tegra_ion.c  | 6 ++----
 3 files changed, 7 insertions(+), 14 deletions(-)

-- 
2.1.3

