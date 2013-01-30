Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3A3JSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:18:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3A3JR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:17:59 -0500
Date: Wed, 30 Jan 2013 10:17:57 +0100
From: Michal Marek <mmarek@suse.cz>
To: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: kconfig: qconf.cc: fix a compiliation error
 when using make xconfig
Message-ID: <20130130091757.GA3275@sepie.suse.cz>
References: <1359044439-13647-1-git-send-email-rkmahefa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1359044439-13647-1-git-send-email-rkmahefa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 04:20:39PM +0000, Tiana Rakotovao Andriamahefa wrote:
> Le jeudi 24 janvier 2013 à 11:36:31, Michal Marek a écrit :
> > On 16.1.2013 13:26, Tiana Rakotovao Andriamahefa wrote:
> > > I have checked it and found that the error was effectively fixed in the last
> > > maintained upload of Qt3 in 2011. However, the correction is not yet in Wheezy
> > > (Debian testing) which I have used for more than a year. It might be
> > > included there one day!
> > > This is the case of Debian, but not all distros.
> > 
> > OK. And it is dead upstream. So I'll apply your patch. Could you please
> > resend it? I deleted the email already.
> 
> Here is the patch.
> 
> When using make xconfig, the following compilation error appears :
>    /usr/include/qt3/qvaluelist.h:427:13: error: ‘ptrdiff_t’ does not name a type
> Including stddef.h in scripts/kconfig/qconf.cc permits to avoid this error.
> 
> Signed-off-by: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>

Thanks, applied to kbuild.git#kconfig.

Michal
