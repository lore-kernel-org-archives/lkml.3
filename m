Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3AVVIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:08:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3AVVIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:08:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <rob@ti.com>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
Date: Tue, 22 Jan 2013 21:07:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <201301221747.24618.arnd@arndb.de> <50FED76B.10801@ti.com>
In-Reply-To: <50FED76B.10801@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301222107.55437.arnd@arndb.de>
X-Provags-ID: V02:K0:CV4j7gJRoVEdTCh+IkbBf94/+5DRiDOpERGTPfXleCZ
 tBEqk+QbA5RTdWZHP+4XjSiEXDuVBCSWQiXSA72GtUmGNOU6No
 wxwLBvlXY+5/R5a5dIhhibBqICgwCJQx0t88/sP8s3fwOenCBF
 AStDdDs7/zl3+ZHrFDFHySbT2nrVD/W/jCefSJE/P4hUFJlO/n
 ibprnjLJs31RCfOqIZI/FixNu+WYvORSUhjTtPv3o8xdsKhORm
 oA49GEQMQd1FE7jmzWHUEVYqr9l/wTwzlPo2PpxvBJo4FBpdWq
 bsT7ABfGd17tu+AUQDlRnJkXIYrEKAg4eY1wVY4uvvBqsWnFpW
 D3zPSpl4L/nchhQ35a4E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Rob Clark wrote:
> I think it should be safe.. or at least it built fine for multi-plat in 
> the recent past and shouldn't really do anything if there is no omapdss 
> platform device.
> 
> Do you want me to make a patch or are you already doing this?

Please make one. Feel free to reuse my changeset description if needed.

	Arnd
