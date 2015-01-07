Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbbAGLAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:00:53 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39514 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbbAGLAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <20150107083654.GK15033@mwanda>
References: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
	<20150107083654.GK15033@mwanda>
Date: Wed, 7 Jan 2015 13:00:51 +0200
Message-ID: <CANZNk82zWJRNFi_pgSpy-1Ts+5tbRUd9q7ST6VYT83cf8d-JDg@mail.gmail.com>
Subject: Re: lustre/lnet/lnet/lib-move.c: memcpy with (struct
 iovec*)->iov_base, which is __user
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, HPDD-discuss@ml01.01.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-07 10:36 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> Didn't Al change these to kvec instead of iovec?  You have to look at
> the callers to figure out if it's actually a user space pointer or a
> kernel pointer.

I am looking at current linux-next checkout.

-- 
Andrey Utkin
