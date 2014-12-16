Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaLPG5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:57:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaLPG5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:57:46 -0500
Date: Tue, 16 Dec 2014 08:57:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 00/18] uaccess: fix sparse warning on get_user for
 bitwise types
Message-ID: <20141216065732.GA9832@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <CAFiDJ5_fGWx2E1jvU+k0Tv_esRpWmC-p+kq7Y_VOr5bx2ZUFzg@mail.gmail.com>
 <20141215101703.GA26156@redhat.com>
 <CAFiDJ5_BSMXBsv0gmzogyJi1x9-4vAhPpZBwn-_CHYDs0pOfvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFiDJ5_BSMXBsv0gmzogyJi1x9-4vAhPpZBwn-_CHYDs0pOfvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 02:06:50PM +0800, Ley Foon Tan wrote:
> On Mon, Dec 15, 2014 at 6:17 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > Thanks for the heads up.
> > No - it will probably need a similar fix for __get_user and get_user.
> > It's just a parse warning so it's not a blocker.
> > Can you fix it yourself or prefer me to?
> Do you have newer revision of this series?

I didn't find a reason to create a newer revision yet.

> If yes, then it is great if you can include it. Otherwise, I can fix it.
> 
> Regards
> 
> Ley Foon
