Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab3GPOmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:42:31 -0400
Received: from p-mail1.rd.orange.com ([195.101.245.15]:54788 "EHLO
	p-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab3GPOma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:42:30 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 3/3] kconfig: cleanup symbol-search code
Date: Tue, 16 Jul 2013 16:42:28 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.10-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr> <1373738905-23396-4-git-send-email-yann.morin.1998@free.fr> <1373985227.4513.12.camel@chaos.site>
In-Reply-To: <1373985227.4513.12.camel@chaos.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201307161642.28527.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 16 Jul 2013 14:42:28.0913 (UTC) FILETIME=[B225F210:01CE8232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, All,

On Tuesday 16 July 2013 16:33:47 Jean Delvare wrote:
> Le Saturday 13 July 2013 à 20:08 +0200, Yann E. MORIN a écrit :
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > - no need for a double-indirection for the temporary sym_match_arr array
> > - the temporary sym_match_arr array is not NULL terminated, so no need
> >   to allocate n+1 elements
> > - two minor style fixes
> > - grammar fix in comment
> > 
> > Reported-by: Jean Delvare <jdelvare@suse.de>
> > Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > ---
> >  scripts/kconfig/symbol.c | 39 +++++++++++++++------------------------
> >  1 file changed, 15 insertions(+), 24 deletions(-)
> >  (...)
> 
> You mixed style cleanups with actual code changes, which is usually
> avoided. Michal may ask you to split these changes into two separate
> patches.

Yes, I initially did three patches (style cleanups, n+1 elem, then
double-indirection), and I eventually decided to merge them in a single
patch. I don't know why I decided that... :-(

I'll re-split.

> Still, I'm happy with all the changes:
> 
> Reviewed-by: Jean Delvare <jdelvare@suse.de>

Thank you! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
