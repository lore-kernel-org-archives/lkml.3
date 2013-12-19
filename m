Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3LRX7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:59:52 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:35107 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3LRX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:59:50 -0500
Message-ID: <1387411248.5567.4.camel@haakon3.risingtidesystems.com>
Subject: Re: randconfig build error with next-20131218, in
 drivers/target/target_core_alua.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Date: Wed, 18 Dec 2013 16:00:48 -0800
In-Reply-To: <CA+r1ZhieKb_Y-e51vud0Ot5xm2O+hkp7nX6tNPpcZ02zVRq+9w@mail.gmail.com>
References: <CA+r1ZhieKb_Y-e51vud0Ot5xm2O+hkp7nX6tNPpcZ02zVRq+9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On Wed, 2013-12-18 at 06:45 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `core_alua_state_lba_dependent':
> /home/jim/linux/drivers/target/target_core_alua.c:492: undefined
> reference to `__umoddi3'
> make: *** [vmlinux] Error 1

Thanks for the heads up.  A patch for this has been merged into the
original, and will be appearing in today's (12192013) linux-next tree.

Thank you,

--nab

