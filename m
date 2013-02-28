Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3B1W6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:58:24 -0500
Received: from mout.gmx.net ([212.227.15.19]:58746 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3B1W6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:58:23 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX198bihQENJ8mj9ToDOiAyO1xWz0J2E6M9i842mMD8
	qvqYUSDd2ljGrz
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH RESEND] char/tpm: Convert struct i2c_msg initialization to C99 format
Date: Thu, 28 Feb 2013 23:58:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.7; KDE/4.9.5; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, tpmdd-devel@lists.sourceforge.net,
        Kent Yoder <key@linux.vnet.ibm.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20130228110611.3ed77e92@endymion.delvare> <20130228233235.5f279117@endymion.delvare> <CAM0nabENksjYahD49cx_GnnxN6XbEROo7zgyqP8s33zhcZUYYg@mail.gmail.com>
In-Reply-To: <CAM0nabENksjYahD49cx_GnnxN6XbEROo7zgyqP8s33zhcZUYYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302282358.38102.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'd suggest not to. Mixing actual changes with cleanups is generally
> > discouraged.
> 
>   Yes, please don't do this.  Also because it makes it really
> confusing for me to figure out whether something has been applied or
> not and if I have the right people on the sign off.
> 
>   Peter, can you resend without it?  I'll have a new staging tree with
> everything up in the next day or two.


Yes, no problem.
I'll create a patch without it -
I'll make it this way that you can apply the conversion patch first and then 
the change.

Thanks,
Peter
