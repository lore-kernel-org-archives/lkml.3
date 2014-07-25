Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaGYSOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:14:47 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:55349
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbaGYSOp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:14:45 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] staging: comedi: amplc_dio200 detach cleanups
Thread-Topic: [PATCH 0/3] staging: comedi: amplc_dio200 detach cleanups
Thread-Index: AQHPqCrrTqZFHvbQdki+SyyApbpJ55uxGDEQ
Date: Fri, 25 Jul 2014 18:14:44 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F1E2F9@P3PWEX4MB008.ex4.secureserver.net>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
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

On Friday, July 25, 2014 10:07 AM, Ian Abbott wrote:
> Fix a double free_irq() and do a bit more cleaning up of the "detach"
> routines.
>
> 1) staging: comedi: amplc_dio200_common: prevent extra free_irq()
> 2) staging: comedi: amplc_dio200_common: remove some tests from
>    amplc_dio200_common_detach()
> 3) staging: comedi: amplc_dio200_pci: no need to test board pointer in
>    dio200_pci_detach()
>
>  drivers/staging/comedi/drivers/amplc_dio200_common.c | 9 +++------
>  drivers/staging/comedi/drivers/amplc_dio200_pci.c    | 5 +----
>  2 files changed, 4 insertions(+), 10 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

