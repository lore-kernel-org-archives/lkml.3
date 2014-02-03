Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaBCPDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:03:55 -0500
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:54877 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:03:54 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 10:03:53 EST
X-MXL-Hash: 52efafd91ef9df61-12c5c06565679d6a1fca67ac34ad83ef85c204a4
X-MXL-Hash: 52efadb625a46816-d82241cb486121a5361c131b1f863cecf786a787
Date: Mon, 3 Feb 2014 09:24:09 -0500
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <prometheanfire@gentoo.org>
CC: <Nagalakshmi.Nandigama@lsi.com>, <Sreekanth.Reddy@lsi.com>,
        <support@lsi.com>, <DL-MPTFusionLinux@lsi.com>,
        <linux-scsi@vger.kernel.org>, <JBottomley@parallels.com>,
        <linux-kernel@vger.kernel.org>, <kernel@gentoo.org>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Message-ID: <20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>
In-Reply-To: <52EC60C3.1080103@gentoo.org>
References: <52EC60C3.1080103@gentoo.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.0 cv=cYFlWA/M c=1 sm=1 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a]
X-AnalysisOut: [=9YMJWpya49sA:10 a=_KQqW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9]
X-AnalysisOut: [zAlcOel0A:10 a=uelBKuKpAAAA:8 a=pqWU5g0ZCoEA:10 a=7mOBRU54]
X-AnalysisOut: [AAAA:8 a=TSbVqHtbAAAA:8 a=NEAV23lmAAAA:8 a=SjvTpkdAl7ObOQR]
X-AnalysisOut: [OMlkA:9 a=CjuIK1q_8ugA:10 a=WeOa-AV5lc8A:10]
X-Spam: [F=0.2000000000; CM=0.500; MH=0.500(2014020311); S=0.200(2010122901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 20:49:39 -0600
Matthew Thode <prometheanfire@gentoo.org> wrote:

> I decided to pull a drive while it was in use out of laziness (it was
> open via luks, but not in actual use).  Got a fun trace as a result.
> Just thought you'd like to know :D
> 

Hi Matthew, 

The first trace looks a lot like what I see on mpt2sas driver removal
[1].  I posted a suggested fix back in Dec [2], which you might try,
however it is not reviewed at this point.

[1] http://thread.gmane.org/gmane.linux.scsi/86237
[2] https://github.com/joe-lawrence/linux/compare/scsi_transport_sas_sysfs_warning.patch

Regards,

-- Joe
