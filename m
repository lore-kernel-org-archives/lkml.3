Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaHDQif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:38:35 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:39634
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbaHDQie convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:38:34 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 15/18 v2] staging: comedi: amplc_pci224: put board
 indices in PCI driver_data
Thread-Topic: [PATCH 15/18 v2] staging: comedi: amplc_pci224: put board
 indices in PCI driver_data
Thread-Index: AQHPr9VaC7WDJ7GI1EusQCnKo6//e5vApS/A
Date: Mon, 4 Aug 2014 16:38:34 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F40E85@P3PWEX4MB008.ex4.secureserver.net>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
 <1407150868-2489-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1407150868-2489-1-git-send-email-abbotti@mev.co.uk>
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

On Monday, August 04, 2014 4:14 AM, Ian Abbott wrote:
> The `driver_data` member value from the matched entry of the PCI module
> device table `amplc_pci224_pci_table[]` is passed through to our comedi
> "auto_attach" handler, `pci224_auto_attach()`.  Use that to index
> directly into our static board data array `pci224_boards[]` instead of
> calling `pci224_find_pci_board()` to search for the entry matching the
> PCI device ID.  That function can be removed.  The `devid` and `model`
> members of `struct pci224_board` are no longer needed either and can be
> removed.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> v2: Use C99 syntax for amplc_pci224_pci_table[] initializer.  Thanks to
> Hartley for finding that!

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks,
Hartley

