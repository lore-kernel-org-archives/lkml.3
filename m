Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3JCGhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:37:52 -0400
Received: from p-mail1.rd.orange.com ([195.101.245.15]:31639 "EHLO
	p-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3JCGhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:37:50 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Martin Walch <walch.martin@web.de>
Subject: Re: [PATCH 4/4] kconfig: remove unused definition from scanner
Date: Thu, 3 Oct 2013 08:37:33 +0200
User-Agent: KMail/1.13.5 (Linux/3.10.11-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, Dirk Gouders <dirk@gouders.net>,
        Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
References: <6249343.9Mjtul3lu5@tacticalops> <201310020857.54800.yann.morin.1998@free.fr> <1491733.iNaKkFyqph@tacticalops>
In-Reply-To: <1491733.iNaKkFyqph@tacticalops>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201310030837.33560.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 03 Oct 2013 06:37:34.0682 (UTC) FILETIME=[0B44DBA0:01CEC003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin, All,

On Thursday 03 October 2013 02:30:21 Martin Walch wrote:
> On Wednesday 02 October 2013 08:57:54 Yann E. MORIN wrote:
> > On Wednesday 02 October 2013 08:42:59 Dirk Gouders wrote:
> > > I think you should also regenerate the scanner and add
> > > the new zconf.lex.c_shipped to this patch.
> > 
> > I think sending the re-generated parser as a separate patch helps
> > in reviewing. Ie. I'd prefer a fifth patch.
> > 
> > BTW, regenerating the parser can be done with:
> >     make REGENERATE_PARSERS=1 config
> 
> Actually, I regenerated the scanner. However, the results did not change
> after applying the patch, because the definition that the patch removes
> (ws) is not used anywhere. It is only a cleanup.

OK, then please say so in the commit message.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
