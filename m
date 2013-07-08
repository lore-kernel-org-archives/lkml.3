Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3GHRht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:37:49 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49714 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3GHRhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:37:47 -0400
Date: Mon, 8 Jul 2013 19:37:42 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 13/15] kconfig/[mn]conf: make it explicit in the search
 box that a regexp is possible
Message-ID: <20130708173742.GC3206@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
 <a1ce636f560336ba007bfabb15b167ff31b592cf.1372097219.git.yann.morin.1998@free.fr>
 <1373282724.4298.203.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1373282724.4298.203.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, All,

On 2013-07-08 13:25 +0200, Jean Delvare spake thusly:
> Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > Reported-by: Jean Delvare <jdelvare@suse.de>
> > Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > Cc: Michal Marek <mmarek@suse.cz>
> > ---
> >  scripts/kconfig/mconf.c | 2 +-
> >  scripts/kconfig/nconf.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> > index 6ee4aae..18d3dc9 100644
> > --- a/scripts/kconfig/mconf.c
> > +++ b/scripts/kconfig/mconf.c
> > @@ -401,7 +401,7 @@ static void search_conf(void)
> >  	struct subtitle_part stpart;
> >  
> >  	title = str_new();
> > -	str_printf( &title, _("Enter %s (sub)string to search for "
> > +	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
> >  			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
> 
> While clearer, this also makes the title span over two lines when it
> used to fit on a single one. I would like to suggest the following:
> 
> 	str_printf(&title, _("Enter (sub)string or regexp to search for "
> 			     "(with or without \"%s\")"), CONFIG_);
> 
> Rationale: the "(with or without CONFIG_)" makes things clear enough
> IMHO, making the first occurrence redundant.

OK, I'll send another patch with the text updated with your suggestion.

Thank you! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
