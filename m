Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3BMDBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:01:39 -0500
Received: from mout.gmx.net ([212.227.17.21]:52180 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945Ab3BMDBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:01:37 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/yqaobeqDyVXQifIML1iHPXgRzvJTyTIbRvtIOYT
	+jSvjjcIpnGXnn
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/9] staging/rtl8187se: Remove code without effect
Date: Wed, 13 Feb 2013 04:00:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.4; KDE/4.9.3; x86_64; ; )
Cc: Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302130400.28950.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 13. Februar 2013, 03:54:26 schrieb Peter Huewe:
> Local variable AcmCtrl is never read/used after assignment so we can remove
> all assignments to it and the related code around the assignments.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Sorry wrong distribution list.
Seems my script went a bit nuts.

Will resend with correct list.

Sorry for the noise.

Peter
