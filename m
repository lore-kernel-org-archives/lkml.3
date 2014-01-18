Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaARXAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 18:00:37 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34104 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaARXAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 18:00:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140118223308.GH15466@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
	<1390079163.25980.2.camel@x41>
	<CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
	<20140118221212.GB15543@pd.tnic>
	<CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
	<20140118223308.GH15466@pd.tnic>
Date: Sun, 19 Jan 2014 00:00:32 +0100
X-Google-Sender-Auth: erg9OvguST5KWJAeG24JHvuycV8
Message-ID: <CACPM=kU_S7FRLd47krW5x0P0HYnk0Yx_Rn8WGR_okcUf0eOXrw@mail.gmail.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/18 Borislav Petkov <bp@alien8.de>:
> On Sat, Jan 18, 2014 at 11:24:53PM +0100, Bjarke Istrup Pedersen wrote:
>> I should take all the parts the is not guarded by __KERNEL__, and move
>> them to a uapi header, and then include it at the top of the normal
>> header. Correct understood? :)
>
> Yes, that's basically the approach but be conservative - export only
> stuff which *really* is needed by userspace. And hyperv people should
> sanity-check what you're exporting because once it is out, it is cast in
> stone and there's no changing.
>
Okay - I'll take a look at it, and post a v2 patch in a moment.
>From what I can see, it looks like the userspace parts are all logical
to have exported (quite a few of them are using by the kvp tool, and
the rest makes sense AFAICS).

/Bjarke
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
