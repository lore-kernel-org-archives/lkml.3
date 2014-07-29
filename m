Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaG2Ji2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:38:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaG2Ji1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:38:27 -0400
Date: Tue, 29 Jul 2014 11:38:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Borneo <borneo.antonio@gmail.com>
cc: linux-input@vger.kernel.org, David Barksdale <dbarksdale@uplogix.com>,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH v2] HID: cp2112: add I2C mode
In-Reply-To: <1404775539-10727-1-git-send-email-borneo.antonio@gmail.com>
Message-ID: <alpine.LNX.2.00.1407291138150.16390@pobox.suse.cz>
References: <CAN+gG=F2wyFw0mR2RxSEz_RNPp3a+zr0R3an38NNU4NVDSYFMQ@mail.gmail.com> <1404775539-10727-1-git-send-email-borneo.antonio@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Antonio Borneo wrote:

> cp2112 supports single I2C read/write transactions.
> It can't combine I2C transactions.
> 
> Add master_xfer, using similar code flow as for smbus_xfer.
> 
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> ChangeLog v1->v2:
> - In cp2112_i2c_xfer() set variable "ret" directly with the
>   expected return value: either an error number or the number
>   of transferred messages.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
