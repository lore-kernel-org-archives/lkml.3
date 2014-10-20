Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaJTVkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:40:46 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:64465 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJTVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:40:44 -0400
MIME-Version: 1.0
In-Reply-To: <1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 20 Oct 2014 14:40:43 -0700
X-Google-Sender-Auth: JVaRWfdzOEMXVsfPQgvJLJNWoEk
Message-ID: <CAD=FV=XnBWWKbrey1zmxtAzGYviJJad4pWOC4=bbf2e2OBgaeQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Mon, Oct 20, 2014 at 2:05 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The regulator framework has a set of helpers functions to be used when
> the system is entering and leaving from suspend but these are not called
> on Exynos platforms. This means that the .set_suspend_* function handlers
> defined by regulator drivers are not called when the system is suspended.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

I think you forgot to carry Chanwoo's review:

Reviewed-by: Chanwoo Choi<cw00.choi@samsung.com>

I don't think you've made any changes that would need to invalidate his review.
