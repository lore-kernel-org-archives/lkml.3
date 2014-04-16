Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaDPXgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:36:47 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:50396
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbaDPXgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:36:46 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2 v3] staging: comedi: addi_apci_1564: fixup and
 absorb apci1564_reset()
Thread-Topic: [PATCH 2/2 v3] staging: comedi: addi_apci_1564: fixup and
 absorb apci1564_reset()
Thread-Index: AQHPWcx5E3JVTEoAsUqndpNUltkYo5sU5Pww
Date: Wed, 16 Apr 2014 23:36:44 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E05116@P3PWEX4MB008.ex4.secureserver.net>
References: <1397691269-24940-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397691269-24940-1-git-send-email-chase.southwood@yahoo.com>
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

On Wednesday, April 16, 2014 4:34 PM, Chase Southwood wrote:
>
> Move apci1564_reset() from hwdrv_apci1564.c to addi_apci_1564.c.  The
> function was very messy and failed to reset a couple registers, these
> issues were fixed on the move.

The commit message needs updated. You are no longer moving the function.

Regards,
Hartley

