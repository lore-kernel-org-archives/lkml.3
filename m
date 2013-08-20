Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3HTJEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:04:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35471 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3HTJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:04:50 -0400
Date: Tue, 20 Aug 2013 11:04:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hugh Dickins <hughd@google.com>, Ding Tianhong <dingtianhong@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>, Thomas Graf <tgraf@suug.ch>
Subject: Re: 3.11-rc6 genetlink locking fix offends lockdep
Message-ID: <20130820090448.GB13078@pd.tnic>
References: <alpine.LNX.2.00.1308182143370.906@eggly.anvils>
 <1376899214.14734.6.camel@jlt4.sipsolutions.net>
 <5211FAB3.7080400@huawei.com>
 <1376911362.14734.11.camel@jlt4.sipsolutions.net>
 <alpine.LNX.2.00.1308191147350.1505@eggly.anvils>
 <1376987338.13829.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376987338.13829.7.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:28:58AM +0200, Johannes Berg wrote:
> Something like the patch below, perhaps? Completely untested so far.

Yeah, this one seems to fix it here (I was seeing the same lockdep splat
as Hugh).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
