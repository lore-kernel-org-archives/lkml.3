Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaIJHJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:09:34 -0400
Received: from sym2.noone.org ([178.63.92.236]:37878 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaIJHJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:09:32 -0400
Date: Wed, 10 Sep 2014 09:09:28 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org,
        alan@linux.intel.com, varkabhadram@gmail.com, heiko@sntech.de,
        yingjoe.chen@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 1/2] tty: serial: 8250: Add Mediatek UART driver
Message-ID: <20140910070928.GF3578@distanz.ch>
References: <1410276703-5274-1-git-send-email-matthias.bgg@gmail.com>
 <1410276703-5274-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410276703-5274-2-git-send-email-matthias.bgg@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-09 at 17:31:42 +0200, Matthias Brugger <matthias.bgg@gmail.com> wrote:
> The device has a highspeed register which influences the calcualtion
> of the divisor. The chip lacks support for some baudrates. When requested,
> we set the divisor to the next smaller baudrate and adjust the c_cflag
> accordingly.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

All my previous review comments have been addressed.

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
