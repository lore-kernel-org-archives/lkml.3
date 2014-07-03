Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbaGCOJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:09:38 -0400
Received: from cpanel09.rubas.ch ([195.182.222.79]:58234 "EHLO
	cpanel09.rubas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaGCOJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:09:36 -0400
Message-ID: <1404396572.30947.1.camel@bitron.ch>
Subject: Re: [alsa-devel] [PATCH] ASoC: rsnd: fixup index of SSI mod when
 SRC is used
From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Linux-ALSA <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Simon Horman <horms@verge.net.au>
Date: Thu, 03 Jul 2014 16:09:32 +0200
In-Reply-To: <CA+t-KAiFNi2cdfKQfNYf7svWKXg4sBhPzib+Q7qfONosuwdy7A@mail.gmail.com>
References: <1404299931-21384-1-git-send-email-j@bitron.ch>
	 <CA+t-KAiFNi2cdfKQfNYf7svWKXg4sBhPzib+Q7qfONosuwdy7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.rubas.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.rubas.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2014-07-03 at 22:57 +0900, Kuninori Morimoto wrote:
> If you add this code,
>
>         if (!ssi) {
>                break;
>         } else ...
>  
> then, I guess we can remove this code ?
> 
> 	if (mod[i] == ssi)
> 	break;

I checked the issue on mainline master where the above two lines are not
present yet. Looking at Mark's for-next tree reveals that you already
fixed the issue in a slightly different way (commit c08c3b08). You may
disregard my patch.

Jürg


