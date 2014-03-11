Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaCKRm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:42:57 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:58068
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149AbaCKRmz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:42:55 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Fred Akers <knivey@botops.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] Staging: comedi: addi-data: Fix long CamelCase
 function names
Thread-Topic: [PATCH v2] Staging: comedi: addi-data: Fix long CamelCase
 function names
Thread-Index: AQHPPU/6/O8B+isg3EKcFid9acWnCZrcJjpg
Date: Tue, 11 Mar 2014 17:42:53 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DAD0AF@P3PWEX4MB008.ex4.secureserver.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
 <1394559177-14616-1-git-send-email-knivey@botops.net>
In-Reply-To: <1394559177-14616-1-git-send-email-knivey@botops.net>
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

On Tuesday, March 11, 2014 10:33 AM, Fred Akers wrote:
> This patch fixes a few function names that are very long and are
> not in the correct naming style
>
> Signed-off-by: Fred Akers <knivey@botops.net>
> ---
> This is v2 of "[PATCH] Staging: comedi: apci_1564: Fix long CamelCase function names"
> Changed subject because it no longer applies to only that file exclusively.
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci035.c       |  53 +++++------
>  .../comedi/drivers/addi-data/hwdrv_apci1500.c      |  96 +++++++++-----------
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  62 ++++++-------
>  .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 100 ++++++++++-----------
>  .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  68 +++++++-------
>  .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  24 ++---
>  drivers/staging/comedi/drivers/addi_apci_035.c     |  14 +--
>  drivers/staging/comedi/drivers/addi_apci_1500.c    |  24 ++---
>  drivers/staging/comedi/drivers/addi_apci_1564.c    |  16 ++--
>  drivers/staging/comedi/drivers/addi_apci_3120.c    |  26 +++---
>  drivers/staging/comedi/drivers/addi_apci_3200.c    |  36 ++++----
>  drivers/staging/comedi/drivers/addi_apci_3501.c    |   6 +-
>  12 files changed, 248 insertions(+), 277 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index 80cca95..b22a8ea 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -111,7 +111,7 @@ static int i_Temp;
>  static int i_Flag = 1;
>  /*
>  +----------------------------------------------------------------------------+
> -| Function   Name   : int i_APCI035_ConfigTimerWatchdog                      |
> +| Function   Name   : int apci035_timer_config                      |
>  |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
>  |                      struct comedi_insn *insn,unsigned int *data)                     |
>  +----------------------------------------------------------------------------+

Nitpick... These obvious function comment blocks should be removed.
That should be a separate patch. Maybe a patch 1/2 before this one so
you don't have to update the comments.

> @@ -163,10 +163,9 @@ static int i_Flag = 1;
>  |			                                                         |
>  +----------------------------------------------------------------------------+
>  */
> -static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
> -					 struct comedi_subdevice *s,
> -					 struct comedi_insn *insn,
> -					 unsigned int *data)
> +static int apci035_timer_config(struct comedi_device *dev,
> +				struct comedi_subdevice *s,
> +				struct comedi_insn *insn, unsigned int *data)

Please leave each parameter on a separate line.

Regards,
Hartley

