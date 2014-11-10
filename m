Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaKJRBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:01:32 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50332 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaKJRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:01:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] asm-generic/io.h overhaul
Date: Mon, 10 Nov 2014 18:01:27 +0100
Message-ID: <7499625.xm054LhcvJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141110162520.GA3926@ulmo.nvidia.com>
References: <20141110162520.GA3926@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6ktZjnv365jXhUY48cIiHvqUEH/HOMbo8DlsUhavS0h
 db1OD7hKQDhN/CpPlITBHFbbUD7CBqOlxtf+PHy6FjsU7tK9aN
 3/G5yGuSJ68rMF9/lXtrB12fhjn50q2O4TEzV1zCmldobwhqym
 92bWhiTVpfZLJMqM7yfiY80lpXnT95yPDfksqJ0l6g4g+D5PS8
 0oYUet6MexGlGTv+vs6JOKLqyMQvJCPTE34TkkxaL0Y7hEX+A8
 0p7Eqbn3mj583Ja9wIR6T03hrweqwNnqHccF8EnguuTnpn3tZ0
 1i2osgz4mFXfiPhL9EmV2LSM9l4CCO0TgQHbOahHUpgFF5JaSv
 UdbvrIs4GwkVw24ekFB8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2014 17:25:23 Thierry Reding wrote:
> Hi Arnd,
> 
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> 
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> 
> are available in the git repository at:
> 
>   https://github.com/thierryreding/linux.git asm-generic-io
> 
> for you to fetch changes up to 09a5723983e383e7d627fe3191366761722695bc:
> 
>   arm64: Use include/asm-generic/io.h (2014-11-10 15:59:23 +0100)

I've pulled this into my asm-generic branch again now, let's see if
anything breaks.

	Arnd
