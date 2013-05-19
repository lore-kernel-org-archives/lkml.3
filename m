Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3ESTt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 15:49:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3ESTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 15:49:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
Date: Sun, 19 May 2013 21:48:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <201305161417.28133.arnd@arndb.de> <F8915E01-0FCA-4C9F-8440-63B5A73B349B@gmail.com>
In-Reply-To: <F8915E01-0FCA-4C9F-8440-63B5A73B349B@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305192148.46398.arnd@arndb.de>
X-Provags-ID: V02:K0:MulGmTyyCEjdOAyWwVhAjVVumshGNC3AdwqcxxlY9o0
 h4phONTp2pdNwu0MrU/UgYejnJ61qL1M68lfCbz4FLnnL89fSi
 mmAUjODPlYsVExTCV/JyDzQtBMeLLaV9MycTZ+wRyFqRTWR2ZD
 zFpgI46Jd4ZN/Mih2dfrxE9qPw7pd0uI3Egv/QEIrAMXjT7EEU
 OLw2GJSvmjxzEfpI8S8okiLYGN4wGgAB0NWAg2KHG/eU5Op4fL
 Ifexk9vqRO7YeQ6kTAR7SiR8qPfnu3ZVrjNKRcO1OCjQrfPh38
 5FHMHeHlU+tr/3I1pDPjclekooKXTxrE5AEjD9P5WLXEOMZ/tG
 GmjqbqgiMvYTV+T1KDUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 May 2013, Daniel Tang wrote:
> If the vendors for the on-SOC components are unknown, should we just
> leave the compatible strings as is (i.e. "nspire-XXX")?

In that case, I would use the name of the company that made the SoC.
I believe someone mentioned it was made by LSI logic.

	Arnd
