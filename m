Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3JAV5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:57:17 -0400
Received: from mout.gmx.net ([212.227.17.22]:62821 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab3JAV5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:57:15 -0400
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 01/13] tpm: ibmvtpm: Use %zd formatting for size_t format arguments
Date: Tue, 1 Oct 2013 23:58:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-2-git-send-email-jgunthorpe@obsidianresearch.com>
In-Reply-To: <1379960083-8942-2-git-send-email-jgunthorpe@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201310012358.55880.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:KV3q7wKyyQAl9lR4jU7VJvx0ySL/NXuigiBSkgkXG2gByYX7Jax
 iVdX38aHFheibi96MYlKMP7Tvcy/pWC0lO/uo/50YIB7Jxs221rQE7vtotmLnW/5fWPDm20
 M1XZu/L1GARHao0cphudehmi3scMG2C06MaTAaHxTvuVyHRIYzSIkTZaQrGr5EoC1WTMFcR
 LT4QviHllTbV5vmnJ2NbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. September 2013, 20:14:31 schrieb Jason Gunthorpe:
> This suppresses compile warnings on 32 bit builds.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>


Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Staged here 
https://github.com/PeterHuewe/linux-tpmdd  for-james

