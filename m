Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183AbaDPVnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:43:07 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:36174
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbaDPVnF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:43:05 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 17:43:05 EDT
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] staging: comedi: addi_apci_1564: remove use of
 devpriv->iobase
Thread-Topic: [PATCH 1/2] staging: comedi: addi_apci_1564: remove use of
 devpriv->iobase
Thread-Index: AQHPWG8envwKX4sejUiqm/rn7+qTkJsUxSUA
Date: Wed, 16 Apr 2014 21:37:26 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E04E64@P3PWEX4MB008.ex4.secureserver.net>
References: <1397541235-2574-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397541235-2574-1-git-send-email-chase.southwood@yahoo.com>
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

On Monday, April 14, 2014 10:54 PM, Chase Southwood wrote:
> devpriv->iobase is currently being used to hold the iobase address used to
> read/write the board's registers.  The same address is stored in the
> comedi_device dev->iobase.  We use that instead.  The eventual goal is to
> decrease the driver's use of the struct addi_private, so that it may
> eventually use a much slimmer specialized private struct instead, as the
> other addi_apci_* drivers do.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> This is a (small) first patchset for my more complete cleanup of
> addi_apci_1564 driver.  Hartley, I'd appreciate any review you have
> wrt these specific patches, but also whether I have chosen a good place
> to start.

As good a place as any to start...

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
