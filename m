Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaE1KO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:14:59 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54855 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbaE1KO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:14:58 -0400
Message-ID: <1401272095.28714.30.camel@x220>
Subject: Re: linux-next: build failure after merge of the final tree
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 12:14:55 +0200
In-Reply-To: <1401271041.28714.22.camel@x220>
References: <20140528194629.0757af1b@canb.auug.org.au>
	 <1401271041.28714.22.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2014 10:14:55.0786 (UTC) FILETIME=[AC4628A0:01CF7A5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 11:57 +0200, Paul Bolle wrote:
> On Wed, 2014-05-28 at 19:46 +1000, Stephen Rothwell wrote:
> That may be related to my "staging: rtl8192u: rename
> CONFIG_IEEE80211_CRYPT_TKIP" (see https://lkml.org/lkml/2014/5/26/531 .)
> My message states it was compile tested, but that would be on x86_64.
> Did it only break on powerpc or did powerpc hit this first?

I must have compile tested this with CONFIG_LIB80211_CRYPT_TKIP=m while
the code checks for CONFIG_LIB80211_CRYPT_TKIP only (ie, builtin only).
I'll have to have a better look at this.

Greg, can the cleaning up of this mess involve an entirely new patch? An
incremental patch would leave this build error in a certain range of
commits.


Paul Bolle

