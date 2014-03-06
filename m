Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaCFRs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:48:58 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:49759
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbaCFRs5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:48:57 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] Staging: comedi: addi-data: tidy up timer register
 map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH 4/5] Staging: comedi: addi-data: tidy up timer register
 map defines in hwdrv_apci1564.c
Thread-Index: AQHPOQ1eN5rr9Nhu3EulrEOcn0nC1JrUVhMw
Date: Thu, 6 Mar 2014 17:48:55 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA44A8@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
 <1394090771-7985-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394090771-7985-1-git-send-email-chase.southwood@yahoo.com>
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
> timer registers such that they are all the real offsets to each register,
> rather than a mix of real offsets and adders to those offsets.
> Additionally, the defines have been renamed to assist with shortening
> some lines in excess of 80 characters.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---

Chase,

Same nitpicks as patch 1/5. Otherwise looks good.

Still having trouble applying the patches due to the whitespace in the
new register map defines.

Thanks,
Hartley
