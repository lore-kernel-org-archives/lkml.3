Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaEEQqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:46:21 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:34309
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbaEEQqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:46:20 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] staging: comedi: addi_apci_1564: Further cleanups
Thread-Topic: [PATCH 0/4] staging: comedi: addi_apci_1564: Further cleanups
Thread-Index: AQHPZqTs6HD2Dx4tqUyzKK9Q2N2H+JsyNMUw
Date: Mon, 5 May 2014 16:46:18 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E388BE@P3PWEX4MB008.ex4.secureserver.net>
References: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
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

On Saturday, May 03, 2014 12:54 AM, Chase Southwood wrote:
> Latest patchset in a continuing cleanup of addi_apci_1564.c.  Main focus
> is on the auto_attach() function, but also cleaning up some of the old addi
> common code wrappers.
>
> To be applied on top of my prior patchset to this file (the one beginning
> with [PATCH 1/6] staging: comedi: addi_apci_1564: remove eeprom support code)
>
> Chase Southwood (4):
>   staging: comedi: addi_apci_1564: board has 32 digital outputs
>   staging: comedi: addi_apci_1564: don't allocate unused subdevices
>   staging: comedi: addi_apci_1564: absorb apci1564_reset()
>   staging: comedi: addi_apci_1564: call apci1564_interrupt() directly
>
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 32 -------
>  drivers/staging/comedi/drivers/addi_apci_1564.c    | 98 ++++++++++------------
>  2 files changed, 45 insertions(+), 85 deletions(-)

Looks good.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

