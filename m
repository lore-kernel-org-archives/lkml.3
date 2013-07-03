Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3GCBv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:51:28 -0400
Received: from server506b.appriver.com ([50.56.144.14]:51672 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122Ab3GCBv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:51:27 -0400
X-Note-AR-ScanTimeLocal: 7/2/2013 8:51:25 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G338 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Subject: Re: [PATCH 1/3] aoe: perform I/O completions in parallel
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <20130702144326.f891debce89e6b8f82efa39c@linux-foundation.org>
Date: Tue, 2 Jul 2013 21:51:24 -0400
CC: <ecashin@noserose.net>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-ID: <1FBBF44A-1AD8-4E1B-8863-0AF5DCB8AA84@coraid.com>
References: <cover.1372710099.git.ecashin@coraid.com> <419af57660dd6fbb436e76291c1e532eede0cea3.1372710099.git.ecashin@coraid.com> <20130702144326.f891debce89e6b8f82efa39c@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 2, 2013, at 5:43 PM, Andrew Morton wrote:

> I suggest it's worth adding a comment here mentioning this, and
> explaining why and how that's OK.  If it indeed is OK ;)

OK, thanks.  The resubmission is coming now.

> Also, these patches were sent as being from ecashin@noserose.net.  I
> rewrote that to ecashin@coraid.com which is what I suspect you
> intended.  You can do this override yourself by putting a From: line
> right at the top of the changelog.

Sorry.  I was having email sending troubles, and my workaround had
flaws.  I'll try to remember the from-in-changelog trick, thanks.

-- 
  Ed Cashin
  ecashin@coraid.com


