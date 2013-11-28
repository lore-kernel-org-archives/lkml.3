Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3K1Iak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:30:40 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35962 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213Ab3K1Iah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:30:37 -0500
Date: Thu, 28 Nov 2013 09:30:34 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Tim Kryger <tim.kryger@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Message-ID: <20131128093034.5d61130a@skate>
In-Reply-To: <20131127185448.GA21422@localhost>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org>
	<20131126183559.GA18570@localhost>
	<CAAYSxhqU9GZdaoTjoCAeyQ4h-KPVzU0BH0D1eLYJoFZ+s8tPgQ@mail.gmail.com>
	<20131127185448.GA21422@localhost>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ezequiel Garcia,

On Wed, 27 Nov 2013 15:54:49 -0300, Ezequiel Garcia wrote:

> > An external device may be keeping the UART busy and preventing LCR
> > from being written.
> > 
> > What device is attached to ttyS1?
> 
> There's no device attached at ttyS1. I've just tested this in another
> box and it seems the same error is obtained on each unused port:

Are you sure about this? I suppose you're testing on the Armada XP GP
board, and this board has a 4 ports FTDI chip, and according to the
board schematics the four UARTs are all connected to the FTDI chip. So
from the SoC perspective, ttyS1 is connected to something, as far as I
can understand. Or maybe you also tested Armada XP DB ?

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
