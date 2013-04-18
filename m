Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3DRLHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:07:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3DRLHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:07:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/32] dmaengine: ste_dma40: Supply full Device Tree parsing support
Date: Thu, 18 Apr 2013 13:07:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181307.39002.arnd@arndb.de>
X-Provags-ID: V02:K0:wVUm580GChZloDnqUsy+Z7yWpBzHEXr2NpdZ2yD4Ylj
 9XSuP7JYiXluQHjTajesDeCFwSbqWE+AWnNvbZL4mm1j0ou00G
 +vIMf38IH00rQIzGMRyF4xfQJgq/NYbOqlSZ1cYT50qGJ9WnEL
 0QGLwTNqdjpvZ2BZxtCDbGAqMwBxTQMzFeKgCw0sLe9LvJsH+n
 bP9alUPXdoLcnsx4IMddky4FwN/CtcZGVuoXXlQdrUy4wcMO3i
 uXWQSI+dqG2kATUVGWmzPzvy2xXkmw7lXT0aLLUDgUVSG23QKr
 /OZLS2wvNU/1QtDfATLKjCFt/7/XxJvm8ODvHLqrPDmN2mxdVQ
 UpxbnrqWCympaepqruj8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> +               dma-channels = <0>; /* Zero means read from H/W. */

One more thing: I would not make this a magic value. Better make the property
optional and require it to be correct if present and autodetected if absent.

	Arnd
