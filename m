Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3LDGGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:06:36 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13511 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3LDGGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:06:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Dec 2013 21:59:54 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Dec 2013 11:35:52 +0530
Subject: RE: [PATCH] usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
Thread-Topic: [PATCH] usb: phy-tegra-usb.c: wrong pointer check for remap
 UTMI
Thread-Index: Ac7wpS6oCHRJf89iSw+gcz89vDi8kwAEXWwQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E8C7A8C90@BGMAIL02.nvidia.com>
References: <1386122564-4246-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <529EA886.8010508@wwwdotorg.org>
In-Reply-To: <529EA886.8010508@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Initially Chris sent this patch to Linux-USB alias alone & there I Acked it.
Plz check http://marc.info/?l=linux-usb&m=138475663023376&w=1 

Then he resent the patch to linux-kernel alias with my ACK added.

Thanks,
Venu


> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Wednesday, December 04, 2013 9:29 AM
> To: Chris Ruehl; balbi@ti.com
> Cc: gregkh@linuxfoundation.org; thierry.reding@gmail.com; linux-
> usb@vger.kernel.org; linux-tegra@vger.kernel.org; linux-
> kernel@vger.kernel.org; Venu Byravarasu
> Subject: Re: [PATCH] usb: phy-tegra-usb.c: wrong pointer check for remap
> UTMI
> 
> On 12/03/2013 07:02 PM, Chris Ruehl wrote:
> > usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
> >
> > A wrong pointer was used to test the result of devm_ioremap()
> >
> > Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> > Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> Out of curiosity, when did that ack happen? I didn't see it. But anyway,
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

