Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3BNHXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:23:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:5783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab3BNHXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:23:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="290962997"
Message-ID: <1360826613.12703.156.camel@sauron.fi.intel.com>
Subject: Re: [PATCH RFC 1/5] UBIFS: xattr: protect ui_size and data_len by
 ui_mutex
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Thu, 14 Feb 2013 09:23:33 +0200
In-Reply-To: <1360750998-15191-2-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
	 <1360750998-15191-2-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 11:23 +0100, Marc Kleine-Budde wrote:
> This patch moves the modification of ui->ui_size and ui->data_len in the
> create_xattr() and change_xattr() functions, so that they are protected by the
> ui_mutex as stated in the documenation of the the struct ubifs_inode.
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

I guess this one and 2/5 should have 'Cc: stable@vger.kernel.org',
right?

-- 
Best Regards,
Artem Bityutskiy

