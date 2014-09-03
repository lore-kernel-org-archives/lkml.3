Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbaICRED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:04:03 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:48734
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933169AbaICREA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:04:00 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: ni_at_a2150: range check board index
Thread-Topic: [PATCH] staging: comedi: ni_at_a2150: range check board index
Thread-Index: AQHPxeaM8/VeUO27q0G7sL9vDsYMD5vvpZrg
Date: Wed, 3 Sep 2014 17:03:14 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F8630C@P3PWEX4MB008.ex4.secureserver.net>
References: <1409577210-964-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1409577210-964-1-git-send-email-abbotti@mev.co.uk>
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

On Monday, September 01, 2014 6:14 AM, Ian Abbott wrote:
> The "ni_at_a2150" driver determines the board type by calling
> `a2150_probe()`.  This reads a register and converts it to a board index
> in the range 0 to 3.  However, the board table array it indexes into
> (`a2150_boards[]`) only has 2 entries.  Return an error from the
> Comedi driver "attach" handler `a2150_attach()` if the probed board
> index is beyond the end of the array.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

