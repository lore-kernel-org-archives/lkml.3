Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3FZLUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:20:24 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35303 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3FZLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com> <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 26 Jun 2013 16:50:01 +0530
Message-ID: <CA+V-a8sqNehbk-_KhhGXtAsLcaO6_p661uBgo=ybP663xXPOMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
To: tomi.valkeinen@ti.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi/ Florian

On Thu, May 16, 2013 at 12:40 PM, Lad Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Use devm_ioremap_resource instead of reques_mem_region()/ioremap() and
> devm_request_irq() instead of request_irq().
>
> This ensures more consistent error values and simplifies error paths.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---

Can you pick up this patch and drop 1/2.

Regards,
--Prabhakar Lad
