Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3BNH3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:29:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:18684 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3BNH3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:29:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="285593032"
Message-ID: <1360826960.12703.159.camel@sauron.fi.intel.com>
Subject: Re: [PATCH RFC 5/5] UBIFS: add ubifs_err() to print error reason
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>
Date: Thu, 14 Feb 2013 09:29:20 +0200
In-Reply-To: <1360750998-15191-6-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
	 <1360750998-15191-6-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 11:23 +0100, Marc Kleine-Budde wrote:
>         err = ubifs_init_security(dir, inode, &dentry->d_name);
> -       if (err)
> +       if (err) {
> +               ubifs_err("cannot initialize extended attribute, error %d",
> +                         err);
>                 goto out_cancel;
> +       }

Would you please instead make 'ubifs_init_security()' print the error
message.

-- 
Best Regards,
Artem Bityutskiy

