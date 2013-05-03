Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167Ab3ECLAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:00:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65174 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760924Ab3ECLAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <1367507786-505303-22-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-22-git-send-email-arnd@arndb.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 3 May 2013 16:30:30 +0530
Message-ID: <CA+V-a8sUPwNZq6ed=75_Lq0x_-jy5x4cXcg8BYvZP7b0PQBpcg@mail.gmail.com>
Subject: Re: [PATCH, RFC 21/22] davinci: vpfe_capture needs i2c
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for the patch.

On Thu, May 2, 2013 at 8:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The vpfe_capture driver is implicitly built for three of the davinci
> capture drivers but depends on i2c, so we need to add the dependency
> in Kconfig for each driver using this.
>
>  drivers/media/platform/davinci/vpfe_capture.c: In function 'vpfe_probe':
>  drivers/media/platform/davinci/vpfe_capture.c:1934:2: error: implicit declaration of function 'i2c_get_adapter' [-Werror=implicit-function-declaration]
>  drivers/media/platform/davinci/vpfe_capture.c:1934:11: warning: assignment makes pointer from integer without a cast [enabled by default]
>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
