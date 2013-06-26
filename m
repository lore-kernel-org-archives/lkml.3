Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3FZL5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:57:15 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:40183 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3FZL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <51CAD305.30407@ti.com>
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com> <51CAD305.30407@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 26 Jun 2013 17:26:52 +0530
Message-ID: <CA+V-a8uhK5-QJKifkiSUN6Nz0aBc2moraWQUJPCmZg9zaFX0eg@mail.gmail.com>
Subject: Re: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "Etheridge, Darren" <detheridge@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Wed, Jun 26, 2013 at 5:09 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 16/05/13 10:10, Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Use devm_ioremap_resource instead of reques_mem_region()/ioremap() and
>> devm_request_irq() instead of request_irq().
>>
>> This ensures more consistent error values and simplifies error paths.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/video/da8xx-fb.c |   39 +++++++--------------------------------
>>  1 files changed, 7 insertions(+), 32 deletions(-)
>
> There's something similar in Darren's da8xx-fb series. Can you check if
> there are differences?
>
I don't see similar changes in his patch series.

Darren while you are at it you can take this patch along you series.
let me know how you plan to.

Regards,
--Prabhakar Lad
