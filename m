Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3FJPia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:38:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3FJPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:38:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH] Misc: sram: Remove unneeded check
Date: Mon, 10 Jun 2013 17:38:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1370875433-6386-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1370875433-6386-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101738.23475.arnd@arndb.de>
X-Provags-ID: V02:K0:lYMNoaNAD2/MO1FEsSEjF00kwekRZ3nFJPoXCZoL4LM
 iT9eeoLRhWZna+aSBOc/URhlTgIckU5tW8shuukb7TDKwWWj+9
 RifJgGmxpHqDiZ5Y+uSs72DcyJ/i++tAbqo47di/vPTsMYExqh
 DKOwOKAfqg6Plhg68p4NPjHKnHcex2HQVKk7cVk3lgLOaix4Uz
 qoKok/qEvvsemJJkiPQE3T7yOvEpDwfQejSeE2vHlFjFGbp3y1
 xn3Ph5amz3Mr42yj6pZNU4YKCS9k1eAGFYw5cmUpW1QyvOu5+v
 awmbeJNQSCVkbMm2RYDulPirfqkDNktexZcxoWNMTzpWZy9g2A
 FHlPztJuM9M3kz3J2OS4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013, Alexander Shiyan wrote:
> Patch removes unneeded check for resource since
> devm_ioremap_resource do all for us.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Arnd Bergmann <arnd@arndb.de>
