Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaH1VIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:08:47 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:51705 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaH1VIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140828140654.d5599d2252386df98a57db64@linux-foundation.org>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140828183330.GM13758@tuxdriver.com>
	<20140828120851.07dbd1c52ec287ca169acee4@linux-foundation.org>
	<CAHp75Vdi6jaexNOFV0mLn=sFOSqmLPNKoGwniSnE0oMim0hjTA@mail.gmail.com>
	<20140828140654.d5599d2252386df98a57db64@linux-foundation.org>
Date: Fri, 29 Aug 2014 00:08:45 +0300
Message-ID: <CAHp75VekWtwrPiu76y+Kq9VUQtrGRceL6VHZ+d+LJoCZG+gYWQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] lib: introduce string_escape_mem and %*pE specifier
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 12:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 28 Aug 2014 23:58:45 +0300 Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

[]

>> For now (so far no more comments) it is only couple of trivia fixes
>> (removing useless comments). Would you like to resend whole series or
>> just fixup would be enough?
>
> I fixed up the one Joe commented on.
>
> --- a/lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier-fix
> +++ a/lib/vsprintf.c
> @@ -1111,12 +1111,11 @@ char *escaped_string(char *buf, char *en
>         int len;
>
>         if (spec.field_width == 0)
> -               /* nothing to print */
> -               return buf;
> +               return buf;                             /* nothing to print */
>
>         if (ZERO_OR_NULL_PTR(addr))
> -               /* NULL pointer */
> -               return string(buf, end, NULL, spec);
> +               return string(buf, end, NULL, spec);    /* NULL pointer */
> +
>
>         do {
>                 switch (fmt[count++]) {

Thanks! I'm fine with this fix.


-- 
With Best Regards,
Andy Shevchenko
