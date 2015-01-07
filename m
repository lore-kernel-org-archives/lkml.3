Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbbAGIhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:37:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbbAGIg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:36:59 -0500
Date: Wed, 7 Jan 2015 11:36:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, HPDD-discuss@ml01.01.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: lustre/lnet/lnet/lib-move.c: memcpy with (struct
 iovec*)->iov_base, which is __user
Message-ID: <20150107083654.GK15033@mwanda>
References: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Didn't Al change these to kvec instead of iovec?  You have to look at
the callers to figure out if it's actually a user space pointer or a
kernel pointer.

regards,
dan carpenter

