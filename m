Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3LQLT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:19:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41746 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3LQLT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:19:26 -0500
Date: Tue, 17 Dec 2013 12:19:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Message-ID: <20131217111920.GA30592@pd.tnic>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:38:16PM +0530, Rashika Kheria wrote:
> Include appropriate header file ide-cd.h in ide-cd_verbose.c because
> function ide_cd_log_error() has its prototype declaration in ide-cd.h.
> Also, include linux/ide.h because it contains certain declarations
> necessary for including ide-cd.h.
> 
> This eliminates the following warnings in ide-cd_verbose.c:
> drivers/ide/ide-cd_verbose.c:251:6: warning: no previous prototype for ‘ide_cd_log_error’ [-Wmissing-prototypes]

drivers/ide/ is open only to fixes for serious, real bugs - nothing
else. I wouldn't waste my time with it if I were you.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
