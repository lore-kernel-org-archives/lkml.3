Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaHAM0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:26:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44067 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbaHAM0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:26:24 -0400
Message-ID: <53DB8769.2020409@mev.co.uk>
Date: Fri, 1 Aug 2014 13:26:17 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging: comedi: addi_apci_1564: provide interface
 to read diagnostic status
References: <cover.1406857380.git.chase.southwood@gmail.com>
In-Reply-To: <cover.1406857380.git.chase.southwood@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 02:55, Chase Southwood wrote:
> This patchset creates a simple subdevice to allow for reading of the
> board's diagnostic status, and then removes any code which is related to
> diagnostic interrupts, as the driver will not support these at this time.
>
> Chase Southwood (2):
>    staging: comedi: addi_apci_1564: add subdevice to check diagnostic
>      status
>    staging: comedi: addi_apci_1564: remove diagnostic interrupt support
>      code
>
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 14 --------
>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 41 ++++++++++++----------
>   2 files changed, 22 insertions(+), 33 deletions(-)
>

The Digital Output subdevice should behave more sanely now!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
