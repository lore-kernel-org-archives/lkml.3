Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbbAZRQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:16:41 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:41893
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbbAZRQk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:16:40 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: addi_apci_1032: add comedi driver
 comment
Thread-Topic: [PATCH] staging: comedi: addi_apci_1032: add comedi driver
 comment
Thread-Index: AQHQOXR1e4uk73zWv0CUaNAhhogNNpzSpDdg
Date: Mon, 26 Jan 2015 17:16:39 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260E5B95@P3PWEX4MB008.ex4.secureserver.net>
References: <1422282536-18606-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1422282536-18606-1-git-send-email-abbotti@mev.co.uk>
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

On Monday, January 26, 2015 7:29 AM, Ian Abbott wrote:
> Add a comedi driver comment in a form suitable for importing into
> Comedilib documentation.  The information about the change-of-state
> subdevice has been pulled from other comments in the driver.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/addi_apci_1032.c | 78 +++++++++++++++----------
>  1 file changed, 48 insertions(+), 30 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

