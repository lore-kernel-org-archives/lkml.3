Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3CFI0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:26:09 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:52152 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3CFI0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:26:06 -0500
Date: Wed, 6 Mar 2013 09:26:00 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: jg1.han@samsung.com
Cc: Arnd Bergmann <arnd@arndb.de>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20130306092600.391f123c@skate>
In-Reply-To: <17540873.418471362551288113.JavaMail.weblogic@epml07>
References: <17540873.418471362551288113.JavaMail.weblogic@epml07>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

On Wed, 06 Mar 2013 06:28:08 +0000 (GMT), Jingoo Han wrote:

> Sorry, I did not know that you submitted the patch.

No problem, I'm happy to have one less patch to carry in my PCIe patch
set :)

> Like you, I am developing PCIe Host driver.

Just curious, do you already have some code? Thierry Reding and myself
have been looking at each other's PCIe host driver since a while in
order to make some consistent choices where possible. It would be good
to see your code as well.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
