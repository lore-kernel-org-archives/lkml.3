Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaKLUUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:20:45 -0500
Received: from mout.web.de ([212.227.15.4]:63418 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLUUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:20:44 -0500
Message-ID: <5463C10D.6020409@users.sourceforge.net>
Date: Wed, 12 Nov 2014 21:20:29 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH v2 0/2] staging: rtl8188eu: Deletion of a few unnecessary
 checks
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net> <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net> <alpine.DEB.2.10.1410311900201.2481@hadrien>
In-Reply-To: <alpine.DEB.2.10.1410311900201.2481@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9ydVCzMDuq7ZaEboEr3kmEpNaoM95oraZ6wAcuffiti8//4C2NF
 fUfxuACzAazsEu8qNfN26iHLTk8A5dFOa+ZeeTxzOTUF+HS/3WG0NvZaeIsXGsuVVNXMcRz
 GQtuz5VlH3DlkAJQD7ER+KZHdyHWQTn+hnxUWxF91WxvSBZMYTz3/l5BR0LEQBkWKuFQhv7
 ey7fcdORHTS+czyGmcNCA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Nov 2014 20:42:18 +0100

Another update suggestion was taken into account after patches were applied
from static source code analysis.

Markus Elfring (2):
  staging: rtl8188eu: Deletion of unnecessary checks before three
    function calls
  staging: rtl8188eu: Better memory clean-up in efuse_phymap_to_logical()

 drivers/staging/rtl8188eu/core/rtw_efuse.c   | 13 ++++++++-----
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |  3 +--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c |  3 +--
 drivers/staging/rtl8188eu/core/rtw_xmit.c    |  6 ++----
 drivers/staging/rtl8188eu/os_dep/usb_intf.c  |  6 +++---
 5 files changed, 15 insertions(+), 16 deletions(-)

-- 
2.1.3


