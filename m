Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaK3ORh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:17:37 -0500
Received: from mout.gmx.net ([212.227.17.22]:58257 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaK3ORg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:17:36 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/1] char: tpm: Deletion of unnecessary checks before the function call "tpm_dev_vendor_release"
Date: Sun, 30 Nov 2014 15:22:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.2; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201411301522.42326.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:jYNhYmWnWhi39uRl0xCxlGXfz5NxEWI7vpvlVKTsjF3OdxI/xIZ
 yB9r7IF1h7NK03stSS9PbQLzDIRgUb++HeamFX9/EXyHzvqe41Xk9OrHbmUbb0/oz8EpRJB
 EAnVgAHZ4yvcYGo7uYto0gMEWUX0Vr6Phoq3JO9ch+nFdv5aQc4v9y/0ymTAfy7yeHWahCL
 28e/xoZwHvzx9BgIrE2XQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to my tree:
https://github.com/PeterHuewe/linux-tpmdd for-james

Will be included in the next pull-request.

Thanks,
Peter
