Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab3E1STE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:19:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33599 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964914Ab3E1STB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:19:01 -0400
Message-ID: <1369765141.22004.64.camel@joe-AO722>
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>, Ben Greear <greearb@candelatech.com>,
        Francois Romieu <romieu@fr.zoreil.com>, atomlin@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        riel@redhat.com, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 11:19:01 -0700
In-Reply-To: <1369758577.3301.543.camel@edumazet-glaptop>
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
	 <20130527224149.GA4384@electric-eye.fr.zoreil.com>
	 <51A4D4AD.2010507@candelatech.com>
	 <20130528161518.GC11614@optiplex.redhat.com>
	 <1369758577.3301.543.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 09:29 -0700, Eric Dumazet wrote:
> I would bump nopage_rs to somethin more reasonable, like one hour or one
> day.

Reasonable is harder to specify but perhaps it could
be made runtime configurable.


