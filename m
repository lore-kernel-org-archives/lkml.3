Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbaEGP4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:56:06 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:57021
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932506AbaEGP4E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:56:04 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] staging: comedi: addi_apci_1564: remove boardinfo
Thread-Topic: [PATCH 0/2] staging: comedi: addi_apci_1564: remove boardinfo
Thread-Index: AQHPacJiKoKwOJKKkU22gGafRZvPYps1RfXg
Date: Wed, 7 May 2014 15:56:03 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E3D869@P3PWEX4MB008.ex4.secureserver.net>
References: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1399446163-30234-1-git-send-email-chase.southwood@gmail.com>
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

On Wednesday, May 07, 2014 12:03 AM, Chase Southwood wrote:
> This patchset removes the last dependency on this driver's boardinfo (the
> timer subdevice init), and then removes the boardinfo from the driver.
>
> To be applied on top of my prior patchset "staging: comedi:
> addi_apci_1564: further cleanups"
>
> Chase Southwood (2):
>   staging: comedi: addi_apci_1564: remove check for timer subdevice
>   staging: comedi: addi_apci_1564: remove boardinfo
>
>  drivers/staging/comedi/drivers/addi_apci_1564.c | 40 +++++++------------------
>  1 file changed, 10 insertions(+), 30 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

