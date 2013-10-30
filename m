Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3J3Aip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:38:45 -0400
Received: from mout.gmx.net ([212.227.17.21]:52508 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab3J3Ain (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:38:43 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tpm/tpm_i2c_stm_st33: Check return code of get_burstcount (fix CID: 986658)
Date: Wed, 30 Oct 2013 01:42:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de> <20131030000618.GA5241@kroah.com>
In-Reply-To: <20131030000618.GA5241@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310300142.11716.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:JDKSr34/eA457AoSsevZboPk/kX5z+G18+g6JjXPit/ivQDrd6m
 MimT9m83ELvMh0ci2+R9kvB4JSddwFMzNKvk11hQCW+J+731sJ11s5jxquTe0+4AOOCKiJ7
 /ono6+cSZLwSmOgaxXYoqchVCiYpGLgMuarNHRt8bxKEWpccbeoqaP6159A8mrTFBTzmha7
 5UmVMnEbDfxEjC91kjplg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
> > 
> > CID: 986658
> What is this field for?

That's the scan id in the coverity database.
If you think that's just noise I can leave it out.

Thanks,
Peter 
