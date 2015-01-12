Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbbALSEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:04:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57242 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbALSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:04:33 -0500
Message-ID: <54B40C74.5030102@canonical.com>
Date: Mon, 12 Jan 2015 18:03:32 +0000
From: Colin Ian King <colin.king@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] static code analysis from cppcheck reports:
References: <1421076472-7101-1-git-send-email-colin.king@canonical.com> <CAMuHMdXXRpFM2VkEz6gGMA5tmXEKt0mpfUMbgM=SPBZgwVg3Eg@mail.gmail.com>
In-Reply-To: <CAMuHMdXXRpFM2VkEz6gGMA5tmXEKt0mpfUMbgM=SPBZgwVg3Eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/15 18:02, Geert Uytterhoeven wrote:
> On Mon, Jan 12, 2015 at 4:27 PM, Colin King <colin.king@canonical.com> wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> [drivers/video/fbdev/broadsheetfb.c:673]:
>>   (error) Memory leak: sector_buffer
>>
>> sector_buffer is not being kfree'd on each call to
>> broadsheet_spiflash_rewrite_sector(), so free it.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> So you can make the box go OOM by repeatedly writing to the
> loadstore_waveform device attribute file?

..well, not quickly.

> Do we want this applied to -stable?
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

