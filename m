Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3AUVKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:10:08 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:7308 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab3AUVKG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:10:06 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1358802603!11218848!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Peter Huewe <peterhuewe@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jan 2013 15:10:03 -0600
Subject: RE: [PATCH 1/2] staging/comedi: Add pci_driver.name to skel driver
Thread-Topic: [PATCH 1/2] staging/comedi: Add pci_driver.name to skel driver
Thread-Index: Ac34GLnTAsYZqOA3TreHlFa+xnq11AAAtdCg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A6F6949C@AUSP01VMBX24.collaborationhost.net>
References: <1358801517-18265-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1358801517-18265-1-git-send-email-peterhuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 1:52 PM, Peter Huewe wrote:
> This patch adds the comedi_driver.name to pci_driver.name
> to the skel driver, so we can remove the workaround in drivers.c
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/comedi/drivers/skel.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
> index e2d7970..4a40498 100644
> --- a/drivers/staging/comedi/drivers/skel.c
> +++ b/drivers/staging/comedi/drivers/skel.c
> @@ -713,6 +713,7 @@ static void skel_pci_remove(struct pci_dev *dev)
>  }
>  
>  static struct pci_driver skel_pci_driver = {
> +	.name = "dummy"

Peter,

Missing comma at the end. Did you build this?

Hartley
