Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaDOAw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:52:28 -0400
Received: from smtp106.biz.mail.ne1.yahoo.com ([98.138.207.13]:29943 "HELO
	smtp106.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750909AbaDOAw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:52:27 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 20:52:26 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6d73oHEVM1m6IAvdiYk_L78lTgS.qz9woqYLyQQ68cf8xFD
 FIYL8p.w5aJISwqK8F8npkh_jHC7NBnoNqQkbS3QvJKFzm3Jrap1PflSEyZN
 YxFGofcA8yrU4Kqe1Ml.GgItJqYldfHoFqzpWwGhB3QXLxlmm9WcL17Kef04
 fWe9cUUoYI2bW7.6_66MZr7tBwS_GFpyj93OfnQbR6NN6ZN5psRViSWcrYBh
 nowEQPT0aoqCq5LiA4cczOLyndF1bCZqyRrlzhy3M1nkzX0_JAZGweKuXlF7
 UpfW3jZmfQis5GebsMBTpZZ_zUWu1lm6cEJ9xkMC3d_obCIqxSM7XY5P9eAP
 TsulZXzJhm5uEwJw9czNkEBrp5nxTfC4IrK3pELdjXCf4VQGM1dZCNGSE32L
 JDlNtp0x0hYd5A0bobsjNEkq9HfNkRXOcbwReq2hZvI_JRmHQ05F4uo9XTEG
 u1j6ojXIcEcbgiQujIfF6N_VMCIZd6ejg4Ud3rqz8mipptfO2QwwDDjOV.9k
 Swx7dUxgwsdGiXQ--
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-Rocket-Received: from fdwdc.com (sfking@67.139.206.186 with plain [98.138.105.25])
        by smtp106.biz.mail.ne1.yahoo.com with SMTP; 14 Apr 2014 17:45:45 -0700 PDT
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc
To: linux-kernel@vger.kernel.org
Subject: v3.15-rc1 slab allocator broken on m68knommu (coldfire)
Date: Mon, 14 Apr 2014 17:45:43 -0700
User-Agent: KMail/1.9.9
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        uClinux development list <uclinux-dev@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201404141745.44279.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git bisect suggests it starts somewhere around commit 
f315e3fa1cf5b3317fc948708645fff889ce1e63 slab: restrict the number of objects 
in a slab

but its kinda hard to tell as there is some compile breakage in there as well.

slub and slob seem to still work okay for m68knommu.
