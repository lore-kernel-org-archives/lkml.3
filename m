Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3AOJeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:34:25 -0500
Received: from ra.se.axis.com ([195.60.68.13]:59192 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab3AOJeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:34:21 -0500
Date: Tue, 15 Jan 2013 10:34:18 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cris: arch-v32/drivers/sync_serial.c: fix error macro
 position
Message-ID: <20130115093418.GH23529@axis.com>
References: <1358199990-15905-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358199990-15905-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:46:28PM +0100, Cong Ding wrote:
> the macro CONFIG_ETRAXFS is used in wrong position - all the port[1] related
> stuff should be used only when CONFIG_ETRAXFS is enabled.

Problem should not be possible to see unless you enable
CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT1 also, which has
   depends on ETRAX_SYNCHRONOUS_SERIAL && ETRAXFS
in the Kconfig...

> Signed-off-by: Cong Ding <dinggnu@gmail.com>

...But anyways, the hardware doesn't have the second synchronous serial port
for ARTPEC-3, so for clarity I'll take this in the CRIS tree. My thanks.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
