Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3CRTJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:09:09 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62483 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3CRTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:09:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8v0cPS_KcOrCHCBN5roqLDa49GH8TbGNSb+pEey-iEXEA@mail.gmail.com>
References: <1363506232-11517-1-git-send-email-silviupopescu1990@gmail.com>
	<CA+V-a8v0cPS_KcOrCHCBN5roqLDa49GH8TbGNSb+pEey-iEXEA@mail.gmail.com>
Date: Mon, 18 Mar 2013 21:09:07 +0200
Message-ID: <CAPWTe+JRFKOnOvoF_f_gT_5NGiLHSNWYzBwWcMwDK1Vme3DBEQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: davinci_vpfe: use resource_size()
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org, gregkh@linuxfoundation.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 3:38 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi,
>
> Thanks for the patch!
>
> did you build test this patch ? the above header file(ioport.h) is not
> required in all the
> above files which you included.
>
> Cheers,
> --Prabhakar Lad

Hi,

It would seem I was a bit overzealous. Indeed, there was no need for
that extra include.
I've send a refreshed patch. Would you be so kind as to review it?

Thanks,
Silviu Popescu
