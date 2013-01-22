Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3AVNSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:18:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3AVNSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:18:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 20/33] net: Convert to devm_ioremap_resource()
Date: Tue, 22 Jan 2013 13:17:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        w.sang@pengutronix.de, netdev@vger.kernel.org
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <201301221303.06785.arnd@arndb.de> <20130122130957.GA18165@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130122130957.GA18165@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221317.55097.arnd@arndb.de>
X-Provags-ID: V02:K0:7mOI9LQLlEa9tnOv9F0aPLNgwXrV6BU/Crjfe+dVy6U
 rlskY9oi0SI0h/z0+GZ8kvJ/fQ0bZS4Ws4LYrWSAcmDxfloRQ3
 whCkIysQU/BsAdj34wzOLLEr4aaS5bCQp1xAouws7LDCGNqp9n
 bhVqeDxWlziXVBJ4dKbsS5jZfOI/n4G5hPS+DGNXYSoKdpNseW
 +QYZiMKw6+Tf2kUu5no1UuLygBupYxVSGtGDMIrc1zvwVfmbId
 lyTUcjieADYKPDqeQh7WEcoIR4vePaXG3EHNrTE9uABierkOi6
 3AxPB1CbHU+OsbisjQWX1ImU+WY3yLOCjkmVS5SBAnLxmHHzkt
 sbfuvbnDtVjJfTpiHots=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Thierry Reding wrote:
> > I've had the same problem a couple of times. The best compromise seems
> > to be to Cc only the top-level subsystem maintainers and mailing lists
> > on the first email.
> 
> Even that would have been about 50 addresses IIRC. But perhaps that's
> still the best compromise to avoid any confusion.

Be careful though that the Cc list must not exceed 1024 characters or
it will get rejected by some of the mailing list servers.

	Arnd
