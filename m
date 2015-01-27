Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbbA0WiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:38:25 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:50883 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbbA0WiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <20150126164352.8b40796d5e3b6caebaca3f28@freescale.com>
References: <20150126164352.8b40796d5e3b6caebaca3f28@freescale.com>
Date: Wed, 28 Jan 2015 01:38:23 +0300
Message-ID: <CALYGNiPNRno6QvAMuZ+mWS-2m8CwpjwUxaEo=LOHT57mPkHy6A@mail.gmail.com>
Subject: Re: [PATCH] .mailmap: update Konstantin Khlebnikov's email address
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack.

On Tue, Jan 27, 2015 at 1:43 AM, Kim Phillips
<kim.phillips@freescale.com> wrote:
> get_maintainer.pl returns k.khlebnikov@samsung.com via git history,
> for which emails get rejected:
>
>  RCPT TO:<k.khlebnikov@samsung.com>
>  550 5.1.1 Recipient address rejected: User unknown
>
> Use his other address that passes vger's mxverify:
>
>  RCPT TO:<koct9i@gmail.com>
>  250 2.1.5 OK ir10si13843754pbc.62 - gsmtp
>
> and add his old email address in the wrong email address field.
>
> Cc: Konstantin Khlebnikov <koct9i@gmail.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
>  .mailmap | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/.mailmap b/.mailmap
> index d357e1b..0d971cf 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -73,6 +73,7 @@ Juha Yrjola <juha.yrjola@nokia.com>
>  Juha Yrjola <juha.yrjola@solidboot.com>
>  Kay Sievers <kay.sievers@vrfy.org>
>  Kenneth W Chen <kenneth.w.chen@intel.com>
> +Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
>  Koushik <raghavendra.koushik@neterion.com>
>  Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>  Leonid I Ananiev <leonid.i.ananiev@intel.com>
> --
> 2.2.2
>
