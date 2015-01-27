Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbbA0SfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:35:02 -0500
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:34652
	"EHLO p3plex2out01.prod.phx3.secureserver.netIMP"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754723AbbA0SfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:35:00 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9] staging: comedi: introduce comedi_usb.h header
Thread-Topic: [PATCH 0/9] staging: comedi: introduce comedi_usb.h header
Thread-Index: AQHQOlmWi6y/9pYTwkm78PL6c0FlHpzUSqPA
Date: Tue, 27 Jan 2015 18:34:59 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260EE3BA@P3PWEX4MB002.ex4.secureserver.net>
References: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
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

On Tuesday, January 27, 2015 10:49 AM, Ian Abbott wrote:
> "comedidev.h" includes USB-specific stuff that gets included by all
> comedi drivers including non-USB ones.  Separate it out into its own
> header "comedi_usb.h".  Make the new header include <linux/usb.h> and
> "comedidev.h" so that comedi USB drivers do not need to include them
> explicitly.
>
> 1) staging: comedi: add comedi_usb.h
> 2) staging: comedi: comedi_usb.c: include new "comedi_usb.h" header
> 3) staging: comedi: dt9812: include new "comedi_usb.h" header
> 4) staging: comedi: ni_usb6501: include new "comedi_usb.h" header
> 5) staging: comedi: usbdux: include new "comedi_usb.h" header
> 6) staging: comedi: usbduxfast: include new "comedi_usb.h" header
> 7) staging: comedi: usbduxsigma: include new "comedi_usb.h" header
> 8) staging: comedi: vmk80xx: include new "comedi_usb.h" header
> 9) staging: comedi: comedi_usb.h: move USB stuff out of comedidev.h
>
>  drivers/staging/comedi/comedi_usb.c          |  3 +-
>  drivers/staging/comedi/comedi_usb.h          | 50 ++++++++++++++++++++++++++++
>  drivers/staging/comedi/comedidev.h           | 29 ----------------
>  drivers/staging/comedi/drivers/dt9812.c      |  3 +-
>  drivers/staging/comedi/drivers/ni_usb6501.c  |  3 +-
>  drivers/staging/comedi/drivers/usbdux.c      |  3 +-
>  drivers/staging/comedi/drivers/usbduxfast.c  |  3 +-
>  drivers/staging/comedi/drivers/usbduxsigma.c |  3 +-
>  drivers/staging/comedi/drivers/vmk80xx.c     |  3 +-
>  9 files changed, 57 insertions(+), 43 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

