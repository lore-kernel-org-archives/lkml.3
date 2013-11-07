Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab3KGWLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:11:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3KGWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:11:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 9/9] ARM: add initial support for Marvell Berlin SoCs
Date: Thu, 7 Nov 2013 23:11:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jisheng Zhang <jszhang@marvell.com>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <201311071720.47489.arnd@arndb.de> <527C049B.4030608@gmail.com>
In-Reply-To: <527C049B.4030608@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311072311.21753.arnd@arndb.de>
X-Provags-ID: V02:K0:mlgitWfkebp11KqfGmFBTpyujt8L9znEccrL3wVFbRq
 lDMmQKHlCt3Rl3BESW6NJhMWxdH075GXe7rYaHX3uVAy2JrFfc
 3dC3Ofv+8CWODel1k7U+3Oa3uN37kIZdzCAinL8XLOtaVEQh58
 5iYLyC1AxK89nEAVjjccezPH+W0u0xRRLzKDBmoNI638plwYhe
 oyJi/id5AEGFs+vCBCzAyKzNwGt18uvMpTmOcciRCGS/5JWT3A
 xBX7xNetha1wfzGP1fOo3/bH0SbQxFv9t5aNGTQTNWvBUJBI3K
 yfxtKC/cutjyF4bv5WpDyaaKsqho/B3YRcvXz1+JEh7h2T5vSE
 CVKYtGN4YTmgSvUOAB3Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 November 2013, Sebastian Hesselbarth wrote:
> I haven't looked deeper into this, but I guess it will not be hard
> to make ARM_TWD independent of SMP.

Yes, I agree. Just make sure to look at the list archives to see if someone
already did that work.

	Arnd
