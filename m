Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3FNKSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 06:18:42 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63784 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3FNKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 06:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <51B20922.4070504@wwwdotorg.org>
References: <1370590290-13467-1-git-send-email-acourbot@nvidia.com> <51B20922.4070504@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 14 Jun 2013 19:18:20 +0900
Message-ID: <CAAVeFu+2W7Df-94FvGdwPurKbsnaxFAvKrj6r3C0zGi5L0nT=A@mail.gmail.com>
Subject: Re: [PATCH v3] simplefb: add support for a8b8g8r8 pixel format
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 1:24 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/07/2013 01:31 AM, Alexandre Courbot wrote:
>> A framebuffer of this format is set up by SHIELD's bootloader.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> Acked-by: Olof Johansson <olof@lixom.net>
>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Jean-Christophe, Tomi, do you plan to merge this?

Alex.
