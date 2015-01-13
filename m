Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbbAMKTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:19:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbbAMKTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:19:48 -0500
Date: Tue, 13 Jan 2015 12:19:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 00/40] uaccess: fix sparse warning on get/put_user for
 bitwise types
Message-ID: <20150113101938.GA8299@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <4461163.Sc5FsMDTBa@wuerfel>
 <20150111115504.GA13570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111115504.GA13570@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 01:55:04PM +0200, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2015 at 08:08:57PM +0100, Arnd Bergmann wrote:
> > On Tuesday 06 January 2015 17:43:28 Michael S. Tsirkin wrote:
> > > 
> > > I tested this on x86 only. Since it's just adding __force, should be
> > > trivially safe everywhere?
> > > 
> > > 
> > > Arnd, did you merge v1 already? If yes, can you please replace with
> > > this version?
> > > 
> > 
> > I haven't merged it yet. I see that more Acks and some comments are
> > coming in. Once those are done, could you send a pull request? It
> > might be useful to have a branch that can be shared with architecture
> > trees if necessary to avoid merge conflicts.
> > 
> > 	Arnd
> 
> OK, I got a bunch of acks, mostly it seems to have calmed down.
> Heiko Carstens (s390 maintainer) says he won't apply whitespace changes:
> http://mid.gmane.org/20150107083339.GB4365@osiris
> so I dropped s390 patches.
> 
> The rest is tagged:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/uaccess_for_upstream
> and pushed out to linux-next.
> 
> I'll give it a couple of days there, then send a pull request - Arnd, you
> meant I should send it to you, right?

Dropped tile as well - will go through arch tree.  Let's wait a couple
more days, then merge into arch tree if all's well.
Makes sense?

> -- 
> MST
