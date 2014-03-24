Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaCXJdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:33:22 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9033 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaCXJdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:33:20 -0400
X-IronPort-AV: E=Sophos;i="4.97,719,1389772800"; 
   d="scan'208";a="20953479"
Message-ID: <532FFBDE.7030407@broadcom.com>
Date: Mon, 24 Mar 2014 10:33:18 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: anish singh <anish198519851985@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Disabling gcc inline operation
References: <CAK7N6vrgnNdFvo8as+DrhXurxP+SexN9gi3WFrX_SCO9i2Ybyw@mail.gmail.com>
In-Reply-To: <CAK7N6vrgnNdFvo8as+DrhXurxP+SexN9gi3WFrX_SCO9i2Ybyw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/14 23:31, anish singh wrote:
> Many a time i have got a crash and it is difficult
> to find out the exact function which crashed
> because the crash stack doesn't show the "real"
> function because gcc inlines many functions when
> ever it desires or when it optimizes for speed.
>
> So i don't want gcc to inline any function instead
> just call the function so that i can see the crash
> stack of each function called. I just want to do
> this for debugging. Please let me know how can
> i do that?
>
> What switch command to pass to gcc in the make
> of linux kernel?

You tried to look at gcc.gnu.org, right? Your best options are -O0 
and/or -Og for debugging purposes.

Regards,
Arend

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

