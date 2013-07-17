Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3GQQbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:31:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:59450 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab3GQQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <2425805.RBpmei1UGe@avalon>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com> <2425805.RBpmei1UGe@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 17 Jul 2013 22:00:42 +0530
Message-ID: <CA+V-a8tt0rTBDWQ4hSEi8xWzcp9KSCkSjRhLsFKbbx=ZW510_A@mail.gmail.com>
Subject: Re: [PATCH 0/5] Davinci VPBE use devres and some cleanup
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Jul 17, 2013 at 5:51 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Saturday 13 July 2013 14:20:26 Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch series replaces existing resource handling in the
>> driver with managed device resource.
>
> Thank you for the patches. They greatly simplify the probe/remove functions, I
> like that. For patches 1 to 4,
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
Thanks for the ACK.

> I have the same concern as Joe Perches for patch 5.
>
Ok I'll fix it and repost the alone patch 5/5.

--
Regards,
Prabhakar Lad
