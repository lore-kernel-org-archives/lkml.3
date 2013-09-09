Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3IINQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:16:57 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:29615 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012Ab3IINQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:16:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYCACnJLVKVhxBY/2dsb2JhbAANToM/g3uqMpQ4gTiDGQEBAQMBIxUWKgEQCxgCAgUWCwICCQMCAQIBHyYGCAUBBQIBARkEh1sSsid0kSKBKYtygmUHgmmBNAOZJJNp
X-IronPort-AV: E=Sophos;i="4.90,866,1371052800"; 
   d="scan'208";a="120910622"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 120910622
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <522DCA39.4090505@uclinux.org>
Date: Mon, 09 Sep 2013 23:16:41 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [000/121] 3.2.51-rc1 review
References: <lsq.1378608720.401499712@decadent.org.uk> <522C22DB.9080008@roeck-us.net> <CAMuHMdW6TGdfi+FH=hRWY_hhs5Cb5N9xV1OL0O9Dcs+PfXm2xA@mail.gmail.com>
In-Reply-To: <CAMuHMdW6TGdfi+FH=hRWY_hhs5Cb5N9xV1OL0O9Dcs+PfXm2xA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/13 18:18, Geert Uytterhoeven wrote:
> On Sun, Sep 8, 2013 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> m68k-linux-ld: error: no memory region specified for loadable section
>> `.note.gnu.build-id'
>
> I can't seem to find an explicit fix for that since v3.2.
> Perhaps the fix is a side effect of f84f52a5c15db7d14a534815f27253b001735183
> ("m68knommu: clean up linker script").
>
> Greg, any idea?

Looks like Guenter found follow up patches that fix it. I don't recall
this specific change breaking like this at the time though.

Regards
Greg


>> Details are at http://server.roeck-us.net:8010/builders.
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

