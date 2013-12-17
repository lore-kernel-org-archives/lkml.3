Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3LQRLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:11:41 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:59829 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3LQRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:11:39 -0500
Message-ID: <52B093DE.3010309@cogentembedded.com>
Date: Tue, 17 Dec 2013 21:11:42 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
In-Reply-To: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/17/2013 02:08 PM, Rashika Kheria wrote:

> Include appropriate header file ide-cd.h in ide-cd_verbose.c because
> function ide_cd_log_error() has its prototype declaration in ide-cd.h.
> Also, include linux/ide.h because it contains certain declarations
> necessary for including ide-cd.h.

    You should fix "ide-cd.h" if it depends on <linux/ide.h>, not the .c file 
including it.

> This eliminates the following warnings in ide-cd_verbose.c:
> drivers/ide/ide-cd_verbose.c:251:6: warning: no previous prototype for ‘ide_cd_log_error’ [-Wmissing-prototypes]

> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

WBR, Sergei


