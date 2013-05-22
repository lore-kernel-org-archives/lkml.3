Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3EVV4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:56:47 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:55177 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3EVV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:56:45 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2013 17:56:45 EDT
Date: Wed, 22 May 2013 23:49:07 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org, ben@decadent.org.uk,
        speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: fix warnings by adding __user
 annotations
Message-ID: <20130522214907.GY6142@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Emil Goode <emilgoode@gmail.com>, w.d.hubbs@gmail.com,
	chris@the-brannons.com, kirk@reisers.ca, gregkh@linuxfoundation.org,
	ben@decadent.org.uk, speakup@braille.uwo.ca,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1369248789-25957-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369248789-25957-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emil Goode, le Wed 22 May 2013 20:53:09 +0200, a écrit :
> This patch fixes the following sparse warnings by adding
> __user annotations.
> 
> drivers/staging/speakup/speakup_soft.c:248:34: warning:
>         incorrect type in argument 1 (different address spaces)
>         drivers/staging/speakup/speakup_soft.c:248:34:
>         expected void [noderef] <asn:1>*dst
>         drivers/staging/speakup/speakup_soft.c:248:34:
>         got char *[assigned] cp
> drivers/staging/speakup/speakup_soft.c:272:40: warning:
>         incorrect type in argument 1 (different address spaces)
>         drivers/staging/speakup/speakup_soft.c:272:40:
>         expected char const [noderef] <asn:1>*s
>         drivers/staging/speakup/speakup_soft.c:272:40:
>         got char const *buf
> drivers/staging/speakup/speakup_soft.c:306:17: warning:
>         incorrect type in initializer (incompatible argument 2
>         (different address spaces))
>         drivers/staging/speakup/speakup_soft.c:306:17:
>         expected long ( *read )( ... )
>         drivers/staging/speakup/speakup_soft.c:306:17:
>         got long ( static [toplevel] *<noident> )( ... )
> drivers/staging/speakup/speakup_soft.c:307:18: warning:
>         incorrect type in initializer (incompatible argument 2
>         (different address spaces))
>         drivers/staging/speakup/speakup_soft.c:307:18:
>         expected long ( *write )( ... )
>         drivers/staging/speakup/speakup_soft.c:307:18:
>         got long ( static [toplevel] *<nfile_operationsoident> )( ... )
> 
> drivers/staging/speakup/devsynth.c:29:41: warning:
>         incorrect type in argument 2 (different address spaces)
>         drivers/staging/speakup/devsynth.c:29:41:
>         expected void const [noderef] <asn:1>*from
>         drivers/staging/speakup/devsynth.c:29:41:    got char const *ptr
> drivers/staging/speakup/devsynth.c:62:17: warning:
>         incorrect type in initializer (incompatible argument 2
>         (different address spaces))
>         drivers/staging/speakup/devsynth.c:62:17:
>         expected long ( *read )( ... )
>         drivers/staging/speakup/devsynth.c:62:17:
>         got long ( static [toplevel] *<noident> )( ... )
> drivers/staging/speakup/devsynth.c:63:18: warning:
>         incorrect type in initializer (incompatible argument 2
>         (different address spaces))
>         drivers/staging/speakup/devsynth.c:63:18:
>         expected long ( *write )( ... )
>         drivers/staging/speakup/devsynth.c:63:18:
>         got long ( static [toplevel] *<noident> )( ... )
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

