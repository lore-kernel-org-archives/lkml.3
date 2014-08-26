Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaHZWid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:38:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaHZWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:38:30 -0400
Date: Tue, 26 Aug 2014 15:38:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/12] serial: 8250_pci: Add PCI IDs for Intel Braswell
Message-ID: <20140826223829.GA29137@kroah.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-13-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469363-15901-13-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:29:23PM +0300, Andy Shevchenko wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Add new PCI IDs to cover newer Intel SoCs such as Braswell.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/tty/serial/8250/8250_pci.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
