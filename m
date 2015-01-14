Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbbANM7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:59:06 -0500
Received: from foo.stuge.se ([212.116.89.98]:51562 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbbANM7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:59:03 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 07:59:03 EST
Message-ID: <20150114125220.32654.qmail@stuge.se>
Date: Wed, 14 Jan 2015 13:52:19 +0100
From: Peter Stuge <peter@stuge.se>
To: Mark Glover <mark@actisense.com>
Cc: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added PIDs for Actisense USB Devices Signed-off-by:
	Mark Glover <mark@actisense.com>
Mail-Followup-To: Mark Glover <mark@actisense.com>, johan@kernel.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421238314-2974-1-git-send-email-mark@actisense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421238314-2974-1-git-send-email-mark@actisense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please update your commit message to leave one blank line between the
commit message summary and the rest of the message. (This avoids your
signed-off-by ending up in the email subject.)

Mark Glover wrote:
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
..
> +#define CHETCO_SEAGAUGE_PID		0xA548 /* SeaGauge USB Adapter */
> +#define CHETCO_SEAGAUGE__PID		0xA549 /* SeaSwitch USG Apadter */

Please make the macro name match the product name. Also note typo^ here.


//Peter
