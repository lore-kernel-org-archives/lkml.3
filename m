Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3LUUMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 15:12:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3LUUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 15:12:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ravi Patel <rapatel@apm.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue Manager/Traffic Manager
Date: Sat, 21 Dec 2013 21:11:40 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Keyur Chudgar <kchudgar@apm.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com>
In-Reply-To: <1387594651-25771-1-git-send-email-rapatel@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312212111.40576.arnd@arndb.de>
X-Provags-ID: V02:K0:+fiz274ZpcXDyh0+xYB+T0MNZrhkqr3+ES2ugT3ho3H
 9LbYO+uBMGOMexGKPlghIGRLf44m8efVMin/rqOeFHpFtMKDYN
 odHAqIybbFpCZAD6kaDlbavXbXToJsTVIX1WeTiu1flk5UApzy
 SvANU07sgDHKgyKm9QDvIfJodiC1RqQ57zKeR+9/izl5SDFAKj
 6YpW9Hn4olr0xqNiDEETNPj3HZiefnJ6XPl+Ai0kPRLyEpeyWv
 Fu6fQDw9RsyMHoYgtLdfJPB9R7IPss3zYQ10KJlGfNmDsi7EhV
 Iim+TOWS+zmzS+e0hsIhuR5Kemy089dcz+Sy6lws3iFJvzUlV7
 XqvAy2a48I3+vsRfvL1E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 December 2013, Ravi Patel wrote:
> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
>  Security Engine subsystems. All subsystems communicate with QMTM using
>  messages which include information about the work to be performed and
>  the location of associated data buffers.  

Please describe here what the purpose of the qmtm is, as this is not
entirely clear from the code.

In particular, please describe how this differs from a dmaengine driver
and why it is not possible to extend the dma slave API to describe qmtm
as a dma engine.

	Arnd
