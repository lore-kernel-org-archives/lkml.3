Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaG3AyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:54:22 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:51341
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbaG3AyU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:54:20 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/19] staging: comedi: amplc_pci230: tidy up a bit
Thread-Topic: [PATCH 00/19] staging: comedi: amplc_pci230: tidy up a bit
Thread-Index: AQHPqyR2SEx7JmO/l0e00vxnl5Hy/Zu3yupg
Date: Wed, 30 Jul 2014 00:54:19 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F28E5A@P3PWEX4MB008.ex4.secureserver.net>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
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

On Tuesday, July 29, 2014 4:58 AM, Ian Abbott wrote:
> 
> Tidy up the "amplc_pci230" driver a bit.  There are more changes to come
> after this.  The only one of these that should alter the object code is
> patch 06, which replaces a udelay() call with usleep_range().
>
> 01) staging: comedi: amplc_pci230: reformat a load of comments
> 02) staging: comedi: amplc_pci230: fix checkpatch line over 80
>     characters
> 03) staging: comedi: amplc_pci230: logical continuations should be on
>     the previous line
> 04) staging: comedi: amplc_pci230: blank lines aren't necessary before a
>     close brace '}'
> 05) staging: comedi: amplc_pci230: alignment should match open
>     parenthesis
> 06) staging: comedi: amplc_pci230: usleep_range is preferred over udelay
> 07) staging: comedi: amplc_pci230: remove unused settling time constants
> 08) staging: comedi: amplc_pci230: remove PCI230_ADC_CONV
> 09) staging: comedi: amplc_pci230: remove PCI230_TEST_BIT()
> 10) staging: comedi: amplc_pci230: add whitespace to register values
> 11) staging: comedi: amplc_pci230: don't begin line with binary operator
> 12) staging: comedi: amplc_pci230: omit '!= 0' from logical expressions
> 13) staging: comedi: amplc_pci230: remove unnecessary braces
> 14) staging: comedi: amplc_pci230: remove some indentation in
>     pci230_ai_check_chanlist()
> 15) staging: comedi: amplc_pci230: no need for '&function'
> 16) staging: comedi: amplc_pci230: add whitespace to pci230_boards[]
> 17) staging: comedi: amplc_pci230: no need to initialize named members
>     to zero
> 18) staging: comedi: amplc_pci230: tidy up stuct pci230_private
> 19) staging: comedi: amplc_pci230: remove some unnecessary parentheses
>
>  drivers/staging/comedi/drivers/amplc_pci230.c | 1417 +++++++++++++------------
>  1 file changed, 736 insertions(+), 681 deletions(-)

Other than my comment about patch 13, this looks ok.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

