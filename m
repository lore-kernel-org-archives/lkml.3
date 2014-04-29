Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060AbaD2Udr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:33:47 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:60807
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbaD2Udq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:33:46 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of
 devpriv->s_EeParameters
Thread-Topic: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of
 devpriv->s_EeParameters
Thread-Index: AQHPY4ZnHPwFiimH2UOrIUkZMgSYGJspCbaQ
Date: Tue, 29 Apr 2014 20:33:45 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E24280@P3PWEX4MB008.ex4.secureserver.net>
References: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
 <1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
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

On, Tuesday, April 29, 2014 1:38 AM, Chase Southwood wrote: 
> This driver no longer reads the eeprom to find the board specific data,
> all the necessary data is in the boardinfo. Use the boardinfo directly
> instead of passing through devpriv->s_EeParameters.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> 2: Incorrect patch title fixed.
>
> Ian and Hartley,
>
> The auto_attach() function is starting to look much better now.  My next patchset
> will be geared towards only allocating subdevices which are actually used.

Other than Ian's comment on patch 4/6 everything looks good to me.

For the series:
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

BTW, for a patch series you should include a cover letter (PATCH 00/xx).

Regards,
Hartley
