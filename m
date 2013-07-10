Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3GJXOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:14:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3GJXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:14:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 03/12] drivers/misc: don't use devm_pinctrl_get_select_default() in probe
Date: Thu, 11 Jul 2013 01:13:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de> <1373471889-18107-3-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1373471889-18107-3-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307110113.58681.arnd@arndb.de>
X-Provags-ID: V02:K0:oUi/fu/XVLDgnbi7GgenCg8+Im4fuM6tGiIrCZzCJZP
 7PTapDfuJAsdoYfiDL1fxwZFA3M74Me5EiwSqqaWrRvOCICs9/
 FfrvK5q9zFshgB8cFPJ7zcEtqvkz3yju0v6vfrVL4I5AH936Da
 4Z4L4GVrxFI67VNdI6pqPDlbvkcHdGPQq5S/vNJYTDipsILdJP
 yRLeHfeU2gv9IDXonKDiLuIGsZSZIdPaBplwnb8rwuq/wnt9d0
 hxkCau4C+iKLyKqC56kdLEZVP30nqtESZoRAxKrFYlqzaO9+EL
 uHl5wYFviOoFGRegBL6RYRMIk6rknrohbloU67OGDSwIaQ40iD
 H2Dr+7YxD7fKvOS6o/q0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 July 2013, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
