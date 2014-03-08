Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaCHA6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:58:36 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:60418
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaCHA6f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:58:35 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/5] Staging: comedi: addi-data: tidy up digital
 input register map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH v3 1/5] Staging: comedi: addi-data: tidy up digital
 input register map defines in hwdrv_apci1564.c
Thread-Index: AQHPOmctfIhLONjgIEOzkA+N7ZSBeJrWXa2w
Date: Sat, 8 Mar 2014 00:58:34 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA8189@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
 <1394239297-25885-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394239297-25885-1-git-send-email-chase.southwood@yahoo.com>
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

On Friday, March 07, 2014 5:42 PM, Chase Southwood wrote:
>
> This patch fixes the register map defines for the digital input registers
> such that they are all the real offsets to each register, rather than a
> mix of real offsets and adders to those offsets.
>
> Further, some of the old defines were being used incorrectly in the
> i_APCI1564_Reset() function.  Upon swapping the old defines out for the
> new ones in this function, their use has been corrected.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---

Much better, thanks!

For the 5 patch series:
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

