Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbaDJRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:35:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:48127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbaDJRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:35:17 -0400
Message-ID: <1397151302.4757.26.camel@jlt4.sipsolutions.net>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Thu, 10 Apr 2014 19:35:02 +0200
In-Reply-To: <5346D456.3010504@openwrt.org>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
		 <53451077.2030102@openwrt.org>
	 (sfid-20140409_111854_192527_B5A21A7B) <1397150173.4757.25.camel@jlt4.sipsolutions.net>
	 <5346D456.3010504@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 19:26 +0200, Felix Fietkau wrote:
> On 2014-04-10 19:16, Johannes Berg wrote:
> > On Wed, 2014-04-09 at 11:18 +0200, Felix Fietkau wrote:
> > 
> >> I'm looking forward to getting rid of patches for older kernels that
> >> often get in the way when using various wireless-testing versions ;)
> > 
> > What do you frequently get conflicts on? I haven't seen any for a long
> > time.
> I don't remember. It was in different areas every time I did an update.

I had a lot of those, but we've converted so much to spatches now that
it hasn't been a concern in a long time (the netlink nlpid/pid thing was
the one that conflicted most for me, but it's long gone)

johannes

