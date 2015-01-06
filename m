Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbbAFKKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:10:31 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:58512 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbbAFKK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:10:27 -0500
Message-ID: <1420539019.1966.7.camel@sipsolutions.net>
Subject: Re: [PATCH] rfkill: parameters documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Clausen <andrew.p.clausen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 06 Jan 2015 11:10:19 +0100
In-Reply-To: <CAAXZBWJD02F81gJkhvLFZcpCzJahr-qsUUgbqheUfrc_BP0CjA@mail.gmail.com> (sfid-20150105_110329_183833_77EE0F7B)
References: <CAAXZBWLOKL8Uu9No_tQga34nFurmeK2HP9qixO1jCXw1Y0t5HA@mail.gmail.com>
	 <1420449884.1898.3.camel@sipsolutions.net>
	 <CAAXZBWJD02F81gJkhvLFZcpCzJahr-qsUUgbqheUfrc_BP0CjA@mail.gmail.com>
	 (sfid-20150105_110329_183833_77EE0F7B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 10:03 +0000, Andrew Clausen wrote:
> Hi Johannes,
> 
> On 5 January 2015 at 09:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> > Looks fine to me (though the commit message shouldn't contain the email
> > "boilerplate" of "hi all" etc - should just be
> 
> Ah, sorry for the extra noise.
> 
> > However I'm not sure I should apply this through my tree?
> 
> I think you're right -- it makes sense to put it in your tree, and
> merge it down the track.  (I don't think I've submitted a kernel patch
> since pre-git days, so sorry for the confusion.)

I'll take it.

However, please resend with an adjust commit message, and please diff it
against my mac80211-next tree (it doesn't apply as is)

johannes

