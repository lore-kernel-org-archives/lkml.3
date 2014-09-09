Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaIIVx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:53:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:12430 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaIIVx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:53:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,493,1406617200"; 
   d="scan'208";a="588832105"
Message-ID: <1410299631.2218.43.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH v5 1/2] tty: serial: 8250: Add Mediatek UART driver
From: Alan Cox <alan@linux.intel.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org,
        varkabhadram@gmail.com, tklauser@distanz.ch, heiko@sntech.de,
        yingjoe.chen@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Date: Tue, 09 Sep 2014 22:53:51 +0100
In-Reply-To: <1410276703-5274-2-git-send-email-matthias.bgg@gmail.com>
References: <1410276703-5274-1-git-send-email-matthias.bgg@gmail.com>
	 <1410276703-5274-2-git-send-email-matthias.bgg@gmail.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 17:31 +0200, Matthias Brugger wrote:
> The device has a highspeed register which influences the calcualtion
> of the divisor. The chip lacks support for some baudrates. When requested,
> we set the divisor to the next smaller baudrate and adjust the c_cflag
> accordingly.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

Reviewed-by: Alan Cox <alan@linux.intel.com>

I'm happy with this version


