Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaABSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:03:30 -0500
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:33139
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbaABSD3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:03:29 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jan 2014 13:03:29 EST
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [PATCH][Resend] Staging: comedi: replace printk() calls with
 dev_dbg() in pcmmio.c
Thread-Topic: [PATCH][Resend] Staging: comedi: replace printk() calls with
 dev_dbg() in pcmmio.c
Thread-Index: AQHPB12sggnzuG9llkGE7V/GfQppi5pxuLtA
Date: Thu, 2 Jan 2014 17:57:56 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817E5C5F9@P3PWEX4MB008.ex4.secureserver.net>
References: <1388627702-7471-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1388627702-7471-1-git-send-email-chase.southwood@yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 01, 2014 6:55 PM, Chase Southwood wrote:
>
> This is a patch for pcmmio.c that changes several printk() calls to dev_dbg() or dev_err() to > fix checkpatch.pl warnings.  Patched from 3.13-rc6.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>  drivers/staging/comedi/drivers/pcmmio.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)

Hello Chase,

This was already fixed, and merged into linux-next, by

commit 4bb82d647dad7be06341ffdb9f07a56a387e213f
Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Tue Nov 26 10:21:23 2013 -0700

    staging: comedi: pcmmio: remove DAMMIT_ITS_BROKEN debug

Please base any comedi patches on linux-next.

Regards,
Hartley

