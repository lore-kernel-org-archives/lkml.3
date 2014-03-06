Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaCFRfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:35:25 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:37206
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbaCFRfY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:35:24 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] Staging: comedi: addi-data: tidy up digital output
 register map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH 2/5] Staging: comedi: addi-data: tidy up digital output
 register map defines in hwdrv_apci1564.c
Thread-Index: AQHPOQ1LOadRe14ojkuPgfwirmOnoprUUdhw
Date: Thu, 6 Mar 2014 17:35:22 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA43B2@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
 <1394090740-7895-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394090740-7895-1-git-send-email-chase.southwood@yahoo.com>
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

On Thursday, March 06, 2014 12:26 AM, Chase Southwood wrote:
> This patch for hwdrv_apci1564.c fixes the register map defines for the
> digital output registers such that they are all the real offsets to each
> register, rather than a mix of real offsets and adders to those offsets.
> Additionally, the defines have been renamed to assist with shortening
> some lines in excess of 80 characters.
>
> Further, some of the old defines were being used incorrectly in the
> i_APCI1564_Reset() function.  Upon swapping the old defines out for the
> new ones in this function, their use has been corrected.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---

Chase,

Same nitpicks as patch 1/5. Otherwise looks good.

Also, I'm having trouble applying your patches for some reason. Please
try applying them locally on your system before posting them.

Thanks,
Hartley
