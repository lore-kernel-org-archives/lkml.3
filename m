Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbaLKBnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:43:09 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:59001 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270AbaLKBnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:43:06 -0500
Date: Thu, 11 Dec 2014 10:41:33 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] kbuild: remove old information in headers_install.txt document
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1417789428.11111.31.camel@opteya.com>
References: <1417494533-24461-1-git-send-email-yamada.m@jp.panasonic.com> <1417789428.11111.31.camel@opteya.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141211104133.A483.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,






On Fri, 05 Dec 2014 15:23:48 +0100
Yann Droneaud <ydroneaud@opteya.com> wrote:

> Hi,
> 
> Le mardi 02 decembre 2014 a 13:28 +0900, Masahiro Yamada a ecrit :
> > The arch header directories "include/asm-*" were moved long before.
> > 
> > Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> > ---
> > 
> >  Documentation/kbuild/headers_install.txt | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
> > index 951eb9f..0d8fe5e 100644
> > --- a/Documentation/kbuild/headers_install.txt
> > +++ b/Documentation/kbuild/headers_install.txt
> > @@ -28,10 +28,7 @@ optional arguments:
> >  
> >  ARCH indicates which architecture to produce headers for, and defaults to the
> >  current architecture.  The linux/asm directory of the exported kernel headers
> > -is platform-specific, to see a complete list of supported architectures use
> > -the command:
> > -
> > -  ls -d include/asm-* | sed 's/.*-//'
> > +is platform-specific.
> >  
> >  INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
> >  "./usr/include".
> 
> Back in september, I've already sent a patch[1] to address this,
> following a discussion with Sam Ravnborg[2]. See the mail thread[3].
> 
> Regards.
> 
> [1] http://lkml.kernel.org/r/b5181cf7604baa454c11f7aa92d07dd05349ce46.1410712841.git.ydroneaud@opteya.com
> [2] http://lkml.kernel.org/r/20140713212608.GB16496@ravnborg.org
> [3] http://lkml.kernel.org/g/cover.1410712841.git.ydroneaud@opteya.com
> 

Sorry, I missed your patch.

You are the first, so I agree yours should go in.



Best Regards
Masahiro Yamada

