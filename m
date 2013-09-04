Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab3IDRwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:52:43 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49911 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859Ab3IDRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:52:41 -0400
Date: Wed, 4 Sep 2013 19:52:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Janani Venkataraman <jananive@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Roland McGrath <roland@hack.frob.com>,
        Amerigo Wang <amwang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, avagin@openvz.org, gorcunov@openvz.org,
        James Hogan <james.hogan@imgtec.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "Randy.Dunlap" <rdunlap@xenotime.net>, Eric Paris <eparis@redhat.com>,
        ananth@in.ibm.com, suzuki@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com
Subject: Re: RFD: Non-Disruptive Core Dump Infrastructure
Message-ID: <20130904175239.GO19750@two.firstfloor.org>
References: <522472DA.4000702@linux.vnet.ibm.com>
 <5225A02B.6080901@linux.vnet.ibm.com>
 <5225BA91.6080904@parallels.com>
 <5225BE3A.3090602@linux.vnet.ibm.com>
 <5225C001.2010208@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5225C001.2010208@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Briefly -- we will implement the CRIU service, which is a daemon running from
> root and listening on a unix socket. When a task wants to dump himself, it sends 
> to the service a "dump me" message. The service then goes and dumps the process.

Maybe I'm missing something, but if the dump file is then readable by
the process and includes the output of the new interfaces
any potential security leaks exposed by the new interfaces would 
be already there for unpriv. users?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
