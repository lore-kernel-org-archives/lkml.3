Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaIBRo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:44:26 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:46502
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710AbaIBRoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:44:25 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/28] staging: comedi: more clean-up and remove legacy
 attach
Thread-Topic: [PATCH 00/28] staging: comedi: more clean-up and remove legacy
 attach
Thread-Index: AQHPxdR3CmNYkESjck6/fcu0LYk0G5vuHlvw
Date: Tue, 2 Sep 2014 17:43:41 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F82ECB@P3PWEX4MB008.ex4.secureserver.net>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
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

On Monday, September 01, 2014 4:04 AM, Ian Abbott wrote:
> Continue to clean up the amplc_pci230 driver code and remove the legacy
> attach mechanism, since it isn't very useful for this driver (see PATCH
> 05/28).

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

