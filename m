Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaIAJzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:55:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaIAJze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:55:34 -0400
Date: Mon, 1 Sep 2014 12:54:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH 3/4] staging: rtl8188eu: osdep_intf.h and usb_intf.c
Message-ID: <20140901095446.GF5122@mwanda>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
 <1408703617-32248-1-git-send-email-cmroliv@gmail.com>
 <20140830204109.GC16168@kroah.com>
 <CAMGgR5tmQE2nWJwBkc5jv_TF=xM+XRf6exGUOA6A-X+7iXqbFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGgR5tmQE2nWJwBkc5jv_TF=xM+XRf6exGUOA6A-X+7iXqbFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 11:22:56PM +0200, Miguel Oliveira wrote:
> > Same comments as the previous ones, please redo all of these patches.
> >
> Should all the alterations be in one big single patch, insted of small ones?

Your first version broke the build if we applied only the first patch.
That's not allowed.

Also the new rtw_sys_remove_one() function isn't called.  I was confused
by it as well.  It doesn't "remove one", it removes everything.

Do we need to support llseek?

How have you tested this?  Have you tested module unloading?

regards,
dan carpenter

