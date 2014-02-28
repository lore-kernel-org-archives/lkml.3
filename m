Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaB1Nzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:55:47 -0500
Received: from mv-drv-hcb004.ocn.ad.jp ([118.23.109.134]:52108 "EHLO
	mv-drv-hcb004.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB1Nzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:55:45 -0500
Date: Fri, 28 Feb 2014 22:55:37 +0900 (JST)
Message-Id: <20140228.225537.367613748.anemo@mba.ocn.ne.jp>
To: broonie@kernel.org
Cc: iivanov@mm-sol.com, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] spi: core: Validate length of the transfers in
 message
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20140228061920.GG29849@sirena.org.uk>
References: <20140226001407.GM2927@sirena.org.uk>
	<20140227.223826.522636360.anemo@mba.ocn.ne.jp>
	<20140228061920.GG29849@sirena.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 15:19:20 +0900, Mark Brown <broonie@kernel.org> wrote:
>> I don't object to the whole patch.  Validating in spi core is good of
>> course, and "xfer->len % w_size" part looks no problem.
> 
>> I just want to keep ways to handle an odd device, for example, which
>> requires long delay between chipselect and the first transfer, etc.
> 
> Can you submit a patch adding that support back please?

OK, I will send a patch against spi.git/for-next branch.

---
Atsushi Nemoto
