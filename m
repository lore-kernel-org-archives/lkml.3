Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbbA2Bfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:35:33 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:58304
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971AbbA2Bf3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:35:29 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ian Abbott <abbotti@mev.co.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@gmail.com>,
        Conrad Meyer <cemeyer@uw.edu>, Fred Akers <knivey@botops.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] staging: comedi: drivers: addi-data: hwdrv_apci1500:
 Removed variables that is never used
Thread-Topic: [PATCH v2] staging: comedi: drivers: addi-data:
 hwdrv_apci1500: Removed variables that is never used
Thread-Index: AQHQO0PPMtO2TIXC+U+2MqsHlPXjEZzWENjw
Date: Wed, 28 Jan 2015 21:48:44 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260F74AD@P3PWEX4MB008.ex4.secureserver.net>
References: <1422481761-31281-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422481761-31281-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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

On Wednesday, January 28, 2015 2:49 PM, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)

This file has been deleted.

Please base comedi patches on the current linux-next tree.

Thanks,
Hartley

