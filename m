Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbaDJHbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:31:33 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:46170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbaDJHbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:31:31 -0400
Message-ID: <1397115086.4757.2.camel@jlt4.sipsolutions.net>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Thu, 10 Apr 2014 09:31:26 +0200
In-Reply-To: <20140409210613.GA14392@kroah.com> (sfid-20140409_230344_484222_1B571B0F)
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
	 <53451077.2030102@openwrt.org>
	 <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
	 <20140409191225.GA10560@kroah.com>
	 <CAB=NE6VqY8yXoYuE0o01vq86imY8EtqLdkPa4bGMvR3bTaj5KQ@mail.gmail.com>
	 <20140409202224.GA12953@kroah.com>
	 <CAB=NE6XY5++p7hJQpQdwrFNUcGbUsKpC+oJiZQciXNduo+8j8A@mail.gmail.com>
	 <20140409210613.GA14392@kroah.com> (sfid-20140409_230344_484222_1B571B0F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 14:06 -0700, Greg Kroah-Hartman wrote:

> Why 3.0?  That's not supported by anyone anymore for "new hardware", I'd
> move to 3.2 if you could, as that's the Debian stable release that will
> be maintained for quite some time yet:
> 	https://www.kernel.org/category/releases.html

We still need 3.0 for an ongoing project.

johannes

