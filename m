Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3AKRSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:18:13 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50373 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3AKRSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:18:11 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2013 12:18:10 EST
MIME-Version: 1.0
In-Reply-To: <1357923834-31641-1-git-send-email-dianders@chromium.org>
References: <1357842269-15062-1-git-send-email-dianders@chromium.org>
	<1357923834-31641-1-git-send-email-dianders@chromium.org>
Date: Fri, 11 Jan 2013 17:12:45 +0000
Message-ID: <CAFbHwiTqpmiStLuLWn=aGQmR9yL+JOtYt=EkSAPf=PnTi0W1xw@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] mmc: dw_mmc: Add "disable-wp" device tree property
From: Will Newton <will.newton@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 5:03 PM, Doug Anderson <dianders@chromium.org> wrote:
> The "disable-wp" property is used to specify that a given SD card slot
> doesn't have a concept of write protect.  This eliminates the need for
> special case code for SD slots that should never be write protected
> (like a micro SD slot or a dev board).
>
> The dw_mmc driver is special in needing to specify "disable-wp"
> because the lack of a "wp-gpios" property means to use the special
> purpose write protect line.  On some other mmc devices the lack of
> "wp-gpios" means that write protect should be disabled.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

This looks ok to me too.

Acked-by: Will Newton <will.newton@imgtec.com>
