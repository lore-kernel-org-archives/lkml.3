Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaDPRew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:34:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaDPReu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:34:50 -0400
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
From: Simo Sorce <ssorce@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
In-Reply-To: <CALCETrU_yKQVZyVug25cxwQFjWJ7Zf20FY-6ht+RJifXtDdDWg@mail.gmail.com>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
	 <20140416002010.GA5035@redhat.com>
	 <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
	 <20140416.085743.1614257692560892039.davem@davemloft.net>
	 <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
	 <1397664837.19767.410.camel@willson.li.ssimo.org>
	 <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
	 <1397667766.19767.440.camel@willson.li.ssimo.org>
	 <CALCETrU_yKQVZyVug25cxwQFjWJ7Zf20FY-6ht+RJifXtDdDWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Apr 2014 13:34:45 -0400
Message-ID: <1397669685.19767.450.camel@willson.li.ssimo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 10:29 -0700, Andy Lutomirski wrote:
> Then please remove SO_PASSCGROUP.

Can you stop demanding changes while demonstrating you haven't well
understood the needs, let alone the consequences ?

Take a day or 2, put your thoughts together and come back with a clear
description of your concerns if you still have any, please.

You clearly do not like this proposal, but you can't really articulate
why, all I hear at this point are the scratches of nails on the glass
wall you are trying to climb.

Seriously, if there are reasonable objections we all want to hear them,
but they need to be clear and circumstanced.

Simo.


