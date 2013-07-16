Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab3GPOjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:39:09 -0400
Received: from p-mail1.rd.orange.com ([195.101.245.15]:19032 "EHLO
	p-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3GPOjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:39:07 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 13/15] kconfig/[mn]conf: make it explicit in the search box that a regexp is possible
Date: Tue, 16 Jul 2013 16:39:04 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.10-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
References: <cover.1372097219.git.yann.morin.1998@free.fr> <20130708173742.GC3206@free.fr> <1373985080.4513.9.camel@chaos.site>
In-Reply-To: <1373985080.4513.9.camel@chaos.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201307161639.04649.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Jul 2013 14:39:05.0050 (UTC) FILETIME=[38A2EBA0:01CE8232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, All,

On Tuesday 16 July 2013 16:31:20 Jean Delvare wrote:
> Le Monday 08 July 2013 à 19:37 +0200, Yann E. MORIN a écrit :
> > On 2013-07-08 13:25 +0200, Jean Delvare spake thusly:
> > > Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
[--SNIP--]
> > > > -	str_printf( &title, _("Enter %s (sub)string to search for "
> > > > +	str_printf( &title, _("Enter %s (sub)string or regexp to search for "
> > > >  			      "(with or without \"%s\")"), CONFIG_, CONFIG_);
> > > 
> > > While clearer, this also makes the title span over two lines when it
> > > used to fit on a single one. I would like to suggest the following:
> > > 
> > > 	str_printf(&title, _("Enter (sub)string or regexp to search for "
> > > 			     "(with or without \"%s\")"), CONFIG_);
> > > 
> > > Rationale: the "(with or without CONFIG_)" makes things clear enough
> > > IMHO, making the first occurrence redundant.
> > 
> > OK, I'll send another patch with the text updated with your suggestion.
> 
> Did you? I can't remember seeing it.

Doh! I forgot that one... Will do.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
