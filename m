Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaDYQIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:08:19 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:49357
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbaDYQIS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:08:18 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] staging: comedi: addi_apci_1564: board does not
 have analog outputs
Thread-Topic: [PATCH 2/2] staging: comedi: addi_apci_1564: board does not
 have analog outputs
Thread-Index: AQHPYF7tgCDWx0QIIk+5iGxkXsu9Wpsif4eg
Date: Fri, 25 Apr 2014 16:08:16 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E18B91@P3PWEX4MB008.ex4.secureserver.net>
References: <1398413826-19400-1-git-send-email-chase.southwood@gmail.com>
 <1398413890-19672-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398413890-19672-1-git-send-email-chase.southwood@gmail.com>
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

On Friday, April 25, 2014 1:18 AM, Chase Southwood wrote:
> The board supported by this driver does not have analog outputs.  Remove
> the subdevice init for it.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>

Looks good.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

