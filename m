Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbaE2QtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:49:21 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:40724
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932795AbaE2QtU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:49:20 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Brooks <frederick.brooks@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] staging: comedi: ni_daq_700: update driver comment
Thread-Topic: [PATCH 1/2] staging: comedi: ni_daq_700: update driver comment
Thread-Index: AQHPey9q/Q/ZkEajhUGcbQFRENe+LJtXxQbA
Date: Thu, 29 May 2014 16:49:19 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E80B25@P3PWEX4MB008.ex4.secureserver.net>
References: <1401362147-5965-1-git-send-email-abbotti@mev.co.uk>
 <1401362147-5965-2-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1401362147-5965-2-git-send-email-abbotti@mev.co.uk>
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

On Thursday, May 29, 2014 4:16 AM, Ian Abbott wrote:
>
> Reformat the comment describing this comedi driver to use the usual
> block comment format.
>
> Also remove reference to digital I/O emulating an 8255, because it
> doesn't, and remove "DIO only" from the "Description:" line as it also
> supports analog inputs.
> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/ni_daq_700.c | 51 ++++++++++++++---------------
>  1 file changed, 25 insertions(+), 26 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

