Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbaE3Qij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:38:39 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:52617
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451AbaE3Qii convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:38:38 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/6] staging: comedi: addi_apci_1564: remove use of
 devpriv->b_OutputMemoryStatus
Thread-Topic: [PATCH 2/6] staging: comedi: addi_apci_1564: remove use of
 devpriv->b_OutputMemoryStatus
Thread-Index: AQHPe8GU8BIktyhF60+xCF9373wfrptZU0FQ
Date: Fri, 30 May 2014 16:38:37 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E83D58@P3PWEX4MB008.ex4.secureserver.net>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
 <1401424943-22029-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1401424943-22029-1-git-send-email-chase.southwood@gmail.com>
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

On Thursday, May 29, 2014 9:42 PM, Chase Southwood wrote:
> This member of the private data struct is only set at one location in the
> entire driver, and then never even used for anything.  Let's just remove
> its use.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeeten <hsweeten@visionengravers.com>
> ---
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 5 -----
>  1 file changed, 5 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

