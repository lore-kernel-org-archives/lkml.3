Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3HPNCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:02:35 -0400
Received: from r-mail1.rd.orange.com ([217.108.152.41]:51014 "EHLO
	r-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3HPNCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:02:31 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [pull request] Pull request for branch yem/kconfig-for-next
Date: Fri, 16 Aug 2013 15:02:23 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.11-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1376600922.git.yann.morin.1998@free.fr> <520E1FAF.3020003@suse.cz>
In-Reply-To: <520E1FAF.3020003@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308161502.25260.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Aug 2013 13:02:26.0249 (UTC) FILETIME=[DB165B90:01CE9A80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Friday 16 August 2013 14:48:47 Michal Marek wrote:
> On 15.8.2013 23:17, Yann E. MORIN wrote:
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > Hello Michal,
> > 
> > Please pull a few more changes queued for 3.12 since your last pull:
> > 
> >   - POSIX compliance when using sed in scripts/config    (CLément)
> >   - use 'long long' to represent hex and ranges, so their width
> >     is not dependent on the architecture (32/64 bits)    (Kees)
> >   - remove the warning when parsing auto.conf, that frigthened
> >     Linus when he merged the ext4 tree
> >   - explicit use CONFIG_MODULES to enable tristates
> 
> Pulled, thanks! Now you can remove the CONFIG_MODULES special handling
> from kconfig.

Eh! Easier said than done! ;-)

Thanks!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
