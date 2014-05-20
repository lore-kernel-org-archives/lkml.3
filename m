Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaETIbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:31:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:11900 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaETIbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:31:06 -0400
From: "Tateno, Tateno" <Shigekatsu.Tateno@atmel.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        "Gujare, Rupesh" <Rupesh.Gujare@atmel.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: ozwpan: Change Maintainer
Thread-Topic: [PATCH] staging: ozwpan: Change Maintainer
Thread-Index: AQHPc20ZNPSdsHert0+plJibdF4zDZtIjZYAgACUD9c=
Date: Tue, 20 May 2014 08:31:03 +0000
Message-ID: <C06F4C2CFA78074B981C5C51CB3AB3FF3482E7E1@hnombx01.corp.atmel.com>
References: <1400509050-6300-1-git-send-email-rupesh.gujare@atmel.com>,<20140520012946.GA12333@kroah.com>
In-Reply-To: <20140520012946.GA12333@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.161.30.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please accept this as the acknowledgment to your reply.
I will take over ozwpan maintainer role from Rupesh.

Thanks

Tateno
________________________________________
From: Greg KH [gregkh@linuxfoundation.org]
Sent: 20 May 2014 02:29
To: Gujare, Rupesh
Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Tateno, Tateno
Subject: Re: [PATCH] staging: ozwpan: Change Maintainer

On Mon, May 19, 2014 at 03:17:30PM +0100, Rupesh Gujare wrote:
> I will be not able to work on ozwpan driver anymore.
> Remove my name & add Tateno as maintainer.
>
> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>  MAINTAINERS                 |    2 +-
>  drivers/staging/ozwpan/TODO |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0de64a5..3a9e4d83 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8466,7 +8466,7 @@ S:      Maintained
>  F:   drivers/staging/olpc_dcon/
>
>  STAGING - OZMO DEVICES USB OVER WIFI DRIVER
> -M:   Rupesh Gujare <rupesh.gujare@atmel.com>
> +M:   Shigekatsu Tateno <shigekatsu.tateno@atmel.com>

Can I get an "ack" from Shigekatsu?  I don't like adding someone as a
maintainer if they don't know about it...

thanks,

greg k-h
