Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaGIUtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:49:22 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48619 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGIUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:49:20 -0400
Date: Wed, 9 Jul 2014 22:49:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Woodhouse <dwmw2@infradead.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/make/headers_install.txt: update
 documentation
Message-ID: <20140709204915.GB32335@ravnborg.org>
References: <1404155479-5638-1-git-send-email-ydroneaud@opteya.com>
 <53B5C734.9020507@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B5C734.9020507@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 11:12:20PM +0200, Michal Marek wrote:
> Dne 30.6.2014 21:11, Yann Droneaud napsal(a):
> > Documentation in make/headers_install.txt is not
> > up to date regarding:
> > - way to list the various architectures;
> > - path where the headers are installed.
> > 
> > This patch try to fix these issues.
> > 
> > Cc: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Rob Landley <rob@landley.net>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> > ---
> >  Documentation/make/headers_install.txt | 15 ++++++++-------
> 
> I have never noticed this file :). How about moving it to
> Documentation/kbuild?
Agree - please get this file moved.

	Sam
