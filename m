Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3GWNzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:55:06 -0400
Received: from p-mail2.rd.orange.com ([195.101.245.16]:53899 "EHLO
	p-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3GWNzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:55:04 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [pull request] Pull request for branch yem-kconfig-rc-fixes
Date: Tue, 23 Jul 2013 15:54:59 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.10-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: Jean Delvare <jdelvare@suse.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1374006854.git.yann.morin.1998@free.fr> <1374055158.4495.1.camel@chaos.site> <51EE8721.10500@suse.cz>
In-Reply-To: <51EE8721.10500@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201307231555.00241.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 23 Jul 2013 13:55:00.0855 (UTC) FILETIME=[39770870:01CE87AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Tuesday 23 July 2013 15:37:37 Michal Marek wrote:
> On 17.7.2013 11:59, Jean Delvare wrote:
> > Le Tuesday 16 July 2013 à 22:39 +0200, Yann E. MORIN a écrit :
> >> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> >>
> >> Hello Michal,
> >>
> >> Please pull these post-rc1 kconfig cleanups, all after
> >> review and comments by Jean:
> >>   - simplify and cleanup the symbol-search code
> >>   - better documentation about the symbols ordering in search results
> >>   - eye-candy in the title of the search-box in [mn]conf
> >>
> >> Regards,
> >> Yann E. MORIN.
> > 
> > It looks very good to me now, thanks Yann for the good work!
> 
> It does look good indeed. But I am wondering if it's necessary for 3.11.
> AFAICS the only user-visible changes are
> 
>   [PATCH 1/6] Documentation/kconfig: more concise and straightforward
> search explanation
>   [PATCH 3/6] kconfig/[mn]conf: shorten title in search-box
> 
> and the rest are code cleanups (however worthwhile), is that correct?
> There is no change in the search behavior, is there? Then I would say
> merge this for 3.12-rc1. Maybe merge the documentation patch for 3.11.

I think you can merge all for 3.12-rc1, in fact.
Even patches 1 and 3 are only eye-candy, and can well wait for 3.12.

Not sure why I wanted them in an -rc in the first place, so I'm fine
with all 6 patches going in for 3.12.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
