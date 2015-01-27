Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbbA0UiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:38:08 -0500
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:57159
	"EHLO p3plex2out01.prod.phx3.secureserver.netIMP"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932613AbbA0UiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:38:06 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/6] staging: comedi: comedi_compat32.[ch] fix and
 tidy up
Thread-Topic: [PATCH v2 0/6] staging: comedi: comedi_compat32.[ch] fix and
 tidy up
Thread-Index: AQHQOl12CAxEfqhMNUmduiztVUyKpZzUbC/Q
Date: Tue, 27 Jan 2015 20:38:04 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260F294A@P3PWEX4MB008.ex4.secureserver.net>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
 <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
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

On Tuesday, January 27, 2015 11:17 AM, Ian Abbott wrote:
> Fix a bug in the handling of the 32-bit compatible version of the
> COMEDI_CMD ioctl and tidy up the rest of the 32-bit compatible ioctl
> handling code a bit.
>
> v2: fix minor niggle in patch 1 and drop patch 7.
>
> 1) staging: comedi: comedi_compat32.c: fix COMEDI_CMD copy back
> 2) staging: comedi: comedi_compat32.h: reformat copyright comment
> 3) staging: comedi: comedi_compat.c: reformat copyright comment
> 4) staging: comedi: comedi_compat32.c: reformat other block comments
> 5) staging: comedi: comedi_compat32.c: align some comments
> 6) staging: comedi: comedi_compat32.c: absorb raw_ioctl()
>
>  drivers/staging/comedi/comedi_compat32.c | 99 +++++++++++++++++---------------
>  drivers/staging/comedi/comedi_compat32.h | 38 ++++++------
>  2 files changed, 73 insertions(+), 64 deletions(-)

Looks better. Thanks.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

