Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaIORjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:39:23 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:53572
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbaIORjV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:39:21 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: remove comedi_board()
Thread-Topic: [PATCH] staging: comedi: remove comedi_board()
Thread-Index: AQHPzmmMRx8cTot7ZUqgBjQPHlwJF5wCeoxQ
Date: Mon, 15 Sep 2014 17:39:19 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA19D9@P3PWEX4MB008.ex4.secureserver.net>
References: <1410513080-29968-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410513080-29968-1-git-send-email-abbotti@mev.co.uk>
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

On Friday, September 12, 2014 2:11 AM, Ian Abbott wrote:
> All calls to the inline function `comedi_board()` in "comedidev.h" have
> been removed, so remove the function.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/comedidev.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index bda5304..7f4d7e5 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -269,11 +269,6 @@ struct comedi_device {
>  	void (*close)(struct comedi_device *dev);
>  };
>  
> -static inline const void *comedi_board(const struct comedi_device *dev)
> -{
> -	return dev->board_ptr;
> -}
> -
>  /*
>   * function prototypes
>   */

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

