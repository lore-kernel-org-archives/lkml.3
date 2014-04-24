Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbaDXSoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:44:09 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:59562
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758840AbaDXSnd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:43:33 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: addi_apci_1564: separate from
 addi_common.c
Thread-Topic: [PATCH] staging: comedi: addi_apci_1564: separate from
 addi_common.c
Thread-Index: AQHPX42LWUj7rEmW10O0lXvZN+Rs5pshE1wA
Date: Thu, 24 Apr 2014 18:43:32 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E1621C@P3PWEX4MB008.ex4.secureserver.net>
References: <1398323941-2596-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1398323941-2596-1-git-send-email-chase.southwood@yahoo.com>
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

On Thursday, April 24, 2014 12:19 AM, Chase Southwood wrote:
> Using the addi-data "common" code in addi_apci_1564 introduces a lot of
> bloat.  By separating this driver off from addi_common.c, a lot of the
> common code can be stripped out.  This patch copies the code over from
> addi_common.c, and removes the #include of the file.  The auto_attach
> function from the common code replaces the one that was previously in this
> driver, though renamed to that it stays within the namespace associated
> with this driver, and the detach function has been renamed for this reason
> as well.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> ---
> Compile tested only.

Looks good.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

