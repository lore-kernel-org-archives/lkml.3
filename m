Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab3AUVcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:32:19 -0500
Received: from mail1.bemta7.messagelabs.com ([216.82.255.50]:28042 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab3AUVcS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:32:18 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 16:32:17 EST
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1358803517!10645035!8
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jan 2013 15:25:17 -0600
Subject: RE: [PATCH 1/2] staging/comedi: Add pci_driver.name to skel driver
Thread-Topic: [PATCH 1/2] staging/comedi: Add pci_driver.name to skel driver
Thread-Index: Ac34HWfHJMhDml0rRNWU9fRcHdPS1AAAA3Cg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A6F694A5@AUSP01VMBX24.collaborationhost.net>
References: <1358801517-18265-1-git-send-email-peterhuewe@gmx.de>
 <ADE657CA350FB648AAC2C43247A983F00207A6F69495@AUSP01VMBX24.collaborationhost.net>
 <201301212225.29314.PeterHuewe@gmx.de>
In-Reply-To: <201301212225.29314.PeterHuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 2:25 PM, Peter Hüwe wrote:
>
> It's okay to drop my patches so you don't have to rebase.
>
>  (I posted a version with the missing comma nevertheless)

Peter,

Your updated versions are ok. I'm about done with the rebase anyway.
Please make sure to at least compile test your patches before posting
in the future.

Greg,

These two patches need to be applied before my cleanup series for
the comedi drivers.c file. I'll be posting them shortly.

Thanks,
Hartley

