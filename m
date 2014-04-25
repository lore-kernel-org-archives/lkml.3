Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaDYQHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:07:42 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:42584
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbaDYQHk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:07:40 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] staging: comedi: addi_apci_1564: board does not
 have analog inputs
Thread-Topic: [PATCH 1/2] staging: comedi: addi_apci_1564: board does not
 have analog inputs
Thread-Index: AQHPYF7N3CbpMQXreUuD0ZnPm7U2+5sifs9A
Date: Fri, 25 Apr 2014 16:07:38 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E18B68@P3PWEX4MB008.ex4.secureserver.net>
References: <1398413826-19400-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398413826-19400-1-git-send-email-chase.southwood@gmail.com>
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

On Friday, April 25, 2014 1:17 AM, Chase Southwood wrote:
> This board does not have analog inputs.  Remove the subdevice init for
> them.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>

Looks good.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

As Ian mentioned, after you have removed the init for all the non-existent
subdevices you should just get rid of them and only allocate the used ones.

Thanks,
Hartley

