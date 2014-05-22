Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaEVQdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:33:07 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:43587
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbaEVQdG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:33:06 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] staging: comedi: addi_apci_1564: move
 apci1564_do_insn_bits() to addi_apci_1564.c
Thread-Topic: [PATCH 2/2] staging: comedi: addi_apci_1564: move
 apci1564_do_insn_bits() to addi_apci_1564.c
Thread-Index: AQHPdVaTT1HixoikC0WYYnwsOwYkbZtMy+Hw
Date: Thu, 22 May 2014 16:33:05 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E6364F@P3PWEX4MB008.ex4.secureserver.net>
References: <1400719209-21452-1-git-send-email-chase.southwood@gmail.com>
 <1400719275-21780-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1400719275-21780-1-git-send-email-chase.southwood@gmail.com>
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

On Wednesday, May 21, 2014 5:41 PM, Chase Southwood wrote:
>
> This function is already compliant with the comedi API and is behaving as
> comedi core expects.  This patch moves it out of
> addi-data/hwdrv_apci1564.c and into the driver proper since no further
> work needs to be done on it.
>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

