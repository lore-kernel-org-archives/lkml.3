Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3E2Drx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:47:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34405 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab3E2Drv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <8619949.XQMpgRNGdV@avalon>
References: <1369573734-19272-1-git-send-email-prabhakar.csengg@gmail.com> <8619949.XQMpgRNGdV@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 29 May 2013 09:17:29 +0530
Message-ID: <CA+V-a8sX7uynnUt9GebH5hu=K_AQ5p-g7mpeSZhRJ5LeF6BhKA@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: mt9p031: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, May 29, 2013 at 9:01 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thanks for the patch.
>
> On Sunday 26 May 2013 18:38:54 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> add OF support for the mt9p031 sensor driver.
>> Alongside this patch sorts the header inclusion alphabetically.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> And added to my tree with three small changes (please see below).
>
Thanks for applying it, with the changes :)

Regards,
--Prabhakar lad
