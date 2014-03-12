Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaCLAHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:07:22 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:46418
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593AbaCLAHU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:07:20 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Fred Akers <knivey@botops.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] Staging: comedi: addi-data: Fix long CamelCase
 function names
Thread-Topic: [PATCH v3 1/2] Staging: comedi: addi-data: Fix long CamelCase
 function names
Thread-Index: AQHPPXf2Uoh1umhkz0qORtT4y4m1EprckVdg
Date: Wed, 12 Mar 2014 00:07:19 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DADD86@P3PWEX4MB008.ex4.secureserver.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
 <1394576353-25247-1-git-send-email-knivey@botops.net>
In-Reply-To: <1394576353-25247-1-git-send-email-knivey@botops.net>
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

On Tuesday, March 11, 2014 3:19 PM, Fred Akers wrote:
> This patch fixes a few function names that are very long and are
> not in the correct naming style
>
> Signed-off-by: Fred Akers <knivey@botops.net>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci035.c       |  58 +++++------
>  .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 106 +++++++++++----------
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  68 ++++++-------
>  .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 104 ++++++++++----------
>  .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  72 +++++++-------
>  .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  24 ++---
>  drivers/staging/comedi/drivers/addi_apci_035.c     |  14 +--
>  drivers/staging/comedi/drivers/addi_apci_1500.c    |  24 ++---
>  drivers/staging/comedi/drivers/addi_apci_1564.c    |  16 ++--
>  drivers/staging/comedi/drivers/addi_apci_3120.c    |  26 ++---
>  drivers/staging/comedi/drivers/addi_apci_3200.c    |  36 +++----
>  drivers/staging/comedi/drivers/addi_apci_3501.c    |   6 +-
>  12 files changed, 277 insertions(+), 277 deletions(-)

This looks fine but I cannot get this or patch 2/2 to apply... 

Assuming it applies cleanly to Greg's tree and you compile tested it,
for both patches:

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

