Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3KAPm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:42:56 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:39991 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3KAPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:42:54 -0400
Message-ID: <1383320566.1737.0.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Ben Hutchings <bhutchings@solarflare.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: Doug Ledford <dledford@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Date: Fri, 1 Nov 2013 15:42:46 +0000
In-Reply-To: <20131031183003.GC25894@hmsreliant.think-freely.org>
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com>
	 <20131030110214.GA10220@localhost.localdomain>
	 <52710B09.6090302@redhat.com>
	 <20131031183003.GC25894@hmsreliant.think-freely.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20260.002
X-TM-AS-Result: No--9.442700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-31 at 14:30 -0400, Neil Horman wrote:
[...]
> It
> functions, but unfortunately the performance lost to the completely broken
> branch prediction that this inflicts makes it a non starter:
[...]

Conditional branches are no good but conditional moves might be worth a shot.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


