Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaE1UVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:21:31 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:64920 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbaE1UVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:21:30 -0400
Message-ID: <1401308488.6186.10.camel@x220>
Subject: Re: linux-next: build failure after merge of the final tree
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 22:21:28 +0200
In-Reply-To: <1401272095.28714.30.camel@x220>
References: <20140528194629.0757af1b@canb.auug.org.au>
	 <1401271041.28714.22.camel@x220> <1401272095.28714.30.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2014 20:21:28.0152 (UTC) FILETIME=[67D08580:01CF7AB2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Wed, 2014-05-28 at 12:14 +0200, Paul Bolle wrote:
> I must have compile tested this with CONFIG_LIB80211_CRYPT_TKIP=m while
> the code checks for CONFIG_LIB80211_CRYPT_TKIP only (ie, builtin only).
> I'll have to have a better look at this.
> 
> Greg, can the cleaning up of this mess involve an entirely new patch? An
> incremental patch would leave this build error in a certain range of
> commits.

The pieces of the latest linux-next build were handed to me by Stephen
as my patch managed to break it.

I'm assuming you'd like to include rtl8192u in linux-next's builds
again. Currently I got nothing to offer to you but a request to either
drop "staging: rtl8192u: rename CONFIG_IEEE80211_CRYPT_TKIP" from
staging-next or, if that's not how staging-next works, a request to
revert it. What do you prefer?

Either way I'll see whether I can come up with a fix that allows me to
take off that brown paper bag.


Paul Bolle

