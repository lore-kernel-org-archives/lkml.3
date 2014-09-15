Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaIOSRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:17:20 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:39848
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbaIOSRR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:17:17 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 05/11] staging: comedi: add comedi_handle_events()
Thread-Topic: [PATCH 05/11] staging: comedi: add comedi_handle_events()
Thread-Index: AQHP0OMPVoXrUx5pHUeh6OgEqnibTJwCgCEA
Date: Mon, 15 Sep 2014 18:17:15 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA1BBE@P3PWEX4MB008.ex4.secureserver.net>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
 <1410785167-28506-6-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410785167-28506-6-git-send-email-abbotti@mev.co.uk>
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

On Monday, September 15, 2014 5:46 AM, Ian Abbott wrote:
> The "comedi_fc" module contains a few functions useful to Comedi
> drivers.  Their functionality is being migrated to the core "comedi"
> module and renamed to start with the prefix `comedi_`.  As part of this
> migration, move `cfc_handle_events()` into the core comedi module and
> rename it to `comedi_handle_events()`.  Change the external declaration
> of `cfc_handle_events()` into an inline function that calls
> `comedi_handle_events()`.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/comedidev.h         |  3 +++
>  drivers/staging/comedi/drivers.c           | 33 ++++++++++++++++++++++++++++++
>  drivers/staging/comedi/drivers/comedi_fc.c | 17 ---------------
>  drivers/staging/comedi/drivers/comedi_fc.h |  7 +++++--
>  4 files changed, 41 insertions(+), 19 deletions(-)

This one, and comedi_event() in comedi_fops.c should probably
be in comedi_buf.c also.

Regards,
Hartley

