Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaJNRFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:05:22 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:35518
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbaJNRFU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:05:20 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] staging: comedi: cb_pcimdas: support PCIe-DAS1602/16
Thread-Topic: [PATCH 0/3] staging: comedi: cb_pcimdas: support
 PCIe-DAS1602/16
Thread-Index: AQHP5uMLcBVLK+MV10i86iliAid28Jwv1AIQ
Date: Tue, 14 Oct 2014 17:05:14 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FE6212@P3PWEX4MB008.ex4.secureserver.net>
References: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
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

On Monday, October 13, 2014 5:41 AM, Ian Abbott wrote:
> Fix up the block comment style and add support for the PCIe-DAS1602/16.
> This is the PCI-Express version of the PCIM-DAS1602/16 and is software
> compatible with it, apart from a different PCI device ID.
>
> 1) staging: comedi: cb_pcimdas: use preferred block comment style
> 2) staging: comedi: cb_pcimdas: update driver comment
> 3) staging: comedi: cb_pcimdas: add support for PCIe-DAS1602/16
>
>  drivers/staging/comedi/Kconfig              |  4 +-
>  drivers/staging/comedi/drivers/cb_pcimdas.c | 82 ++++++++++++++++-------------
>  2 files changed, 46 insertions(+), 40 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

