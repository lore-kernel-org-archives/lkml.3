Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaDWDzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:55:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45376 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbaDWDzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:55:20 -0400
Date: Tue, 22 Apr 2014 23:55:15 -0400 (EDT)
Message-Id: <20140422.235515.1172733305552022632.davem@davemloft.net>
To: rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, hadi@mojatatu.com,
        eparis@redhat.com, sgrubb@redhat.com
Subject: Re: [PATCH 0/6][v2] audit: implement multicast socket for journald
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140423014929.GL20182@madcap2.tricolour.ca>
References: <cover.1398215388.git.rgb@redhat.com>
	<20140422.214300.171999077259349189.davem@davemloft.net>
	<20140423014929.GL20182@madcap2.tricolour.ca>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Apr 2014 20:55:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>
Date: Tue, 22 Apr 2014 21:49:29 -0400

> On 14/04/22, David Miller wrote:
>> From: Richard Guy Briggs <rgb@redhat.com>
>> Date: Tue, 22 Apr 2014 21:31:52 -0400
>> 
>> > This is a patch set Eric Paris and I have been working on to add a restricted
>> > capability read-only netlink multicast socket to kernel audit to enable
>> > userspace clients such as systemd/journald to receive audit logs, in addition
>> > to the bidirectional auditd userspace client.
>> 
>> Series applied, thanks Richard.
> 
> Thanks for your patience, David.  Can I assume you adopted the 3 audit
> patches too, becuase of the dependence?

Yes.
