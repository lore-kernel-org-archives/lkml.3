Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3AVLGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:06:02 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4871 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3AVLF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:05:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 22 Jan 2013 03:05:59 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jan 2013 16:35:52 +0530
Subject: RE: [PATCH] usb: phy: moving all PHY API definitions to usb/phy
 directory
Thread-Topic: [PATCH] usb: phy: moving all PHY API definitions to usb/phy
 directory
Thread-Index: Ac34j8O2DF9tC5KAQla1P90p98iWSgAABJ9g
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1B13B6F0@BGMAIL02.nvidia.com>
References: <1358852210-27814-1-git-send-email-vbyravarasu@nvidia.com>
 <20130122110038.GA685@arwen.pp.htv.fi>
In-Reply-To: <20130122110038.GA685@arwen.pp.htv.fi>
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

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Tuesday, January 22, 2013 4:31 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: phy: moving all PHY API definitions to usb/phy
> directory
> 
> * PGP Signed by an unknown key
> 
> HI,
> 
> On Tue, Jan 22, 2013 at 04:26:50PM +0530, Venu Byravarasu wrote:
> > As drivers/usb/otg/otg.c contains most of the PHY related APIs
> > which are not OTG specific, moving them to more logical place
> > under driver/usb/phy.
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > ---
> >  drivers/usb/otg/otg.c    |  184 ----------------------------------------------
> >  drivers/usb/phy/Makefile |    1 +
> 
> missed git add of the new file, but hey, let's call it phy.c and place
> it on drivers/usb/phy/phy.c

Yeah, I used "git commit -a" & missed adding new file.
Just few min back, sent a patch update.

> 
> Also, you will have to rebase on top of Kishon's latest work which I'll
> apply first.

That's fine.
I'll rebase on top of Kishon's latest work and send v3.  
In that v3 patch, will rename the file as phy.c, as you suggested above.

> 
> --
> balbi
> 
> * Unknown Key
> * 0x35CAA444
