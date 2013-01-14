Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab3ANWUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:20:20 -0500
Received: from mail-wi0-f196.google.com ([209.85.212.196]:47355 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3ANWUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:20:18 -0500
X-Greylist: delayed 87688 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 17:20:17 EST
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH 2/2] nconf:  function keys line, change background color for better readability
Date: Mon, 14 Jan 2013 23:20:12 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp> <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com> <20121229223328.GA28355@mobil.systemanalysen.net>
In-Reply-To: <20121229223328.GA28355@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301142320.13141.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, All,

On Saturday 29 December 2012 Roland Eggner wrote:
> >From: Roland Eggner <edvx1@systemanalysen.net>
> 
> •  In function keys line descriptions black on darkblue are almost impossible
>    to read.  Change colors to black on brown.
> 
> Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
> ---
> --- a/scripts/kconfig/nconf.gui.c	2012-11-16 17:47:22.000000000 +0100
> +++ b/scripts/kconfig/nconf.gui.c	2012-12-23 23:51:40.929833170 +0100
> @@ -48,7 +48,7 @@ static void set_normal_colors(void)
>  	init_pair(INPUT_FIELD, -1, -1);
>  
>  	init_pair(FUNCTION_HIGHLIGHT, -1, -1);
> -	init_pair(FUNCTION_TEXT, COLOR_BLUE, -1);
> +	init_pair(FUNCTION_TEXT, COLOR_YELLOW, -1);

Although I am not a fan of this color scheme, it is much more readable
than the previous black-on-blue. Tested in frame-buffer console, in konsole
and in xterm. And queued in my non-official for-next branch.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

