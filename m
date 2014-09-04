Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaIDACX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:02:23 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:36273
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbaIDACW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:02:22 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: hwdrv_apci1500: use dev->class_dev in
 calls to dev_warn()
Thread-Topic: [PATCH] staging: comedi: hwdrv_apci1500: use dev->class_dev in
 calls to dev_warn()
Thread-Index: AQHPx9MSpdHEvLm4OkCbaFnq1hdmhpvwFmiA
Date: Thu, 4 Sep 2014 00:01:40 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F86D24@P3PWEX4MB008.ex4.secureserver.net>
References: <1409788729-22875-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1409788729-22875-1-git-send-email-chase.southwood@gmail.com>
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

On Wednesday, September 03, 2014 4:59 PM, Chase Southwood wrote:
> git-grep reveals that hwdrv_apci1500.c is the only file in comedi that uses
> dev->hw_dev in calls to dev_{err,warn}().  The rest of the drivers pass
> dev->class_dev to these macros instead.  Switch the dev_warn() calls in
> this driver to use dev->class_dev as well, for consistency.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>

Hmm.. I thought I caught all of these.

Thanks

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

