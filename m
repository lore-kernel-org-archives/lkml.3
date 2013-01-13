Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3AMOXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 09:23:46 -0500
Received: from server505f.appriver.com ([98.129.35.10]:1490 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754846Ab3AMOXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 09:23:44 -0500
X-Note-AR-ScanTimeLocal: 1/13/2013 8:23:43 AM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Josh Boyer <jwboyer@redhat.com>,
        "mitko@banksoft-bg.com" <mitko@banksoft-bg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fedoraproject.org" <kernel-team@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>, Ed Cashin <ecashin@coraid.com>
Date: Sun, 13 Jan 2013 08:23:43 -0600
Subject: Re: Oops on aoe module removal
Thread-Topic: Oops on aoe module removal
Thread-Index: Ac3xmZbrbGmY7JopTRW/OvpJ+b8vKA==
Message-ID: <EA664C14-1CAC-4F04-8E27-4544DA3CC3BE@coraid.com>
References: <20130103132556.GA13290@hansolo.jdub.homelinux.org>
 <587E85C3-7395-4BC1-B31B-426572B5080C@coraid.com>
 <50E5910E.7060606@kernel.dk> <50E591CD.40802@kernel.dk>
 <D2D8353E-8DE1-44A2-BB7F-3FE1E2E794FB@coraid.com>
 <50E5A51C.3030800@kernel.dk>
 <32456405-00CA-43EC-A17A-28452C217A7F@coraid.com>
 <ffc5cf0d1e3273770b65bc7de4a4851e@coraid.com> <50E5DFE4.5020007@kernel.dk>
 <EE162567-A6C8-4C4E-B96F-5366C8DDDCB1@coraid.com>
 <6333449B-1F90-4772-A04A-79E123A8A20D@coraid.com>
 <A7C5A7B8-6494-4D9D-B052-5C623E066985@coraid.com>
 <1358055265.4514.67.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1358055265.4514.67.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 13, 2013, at 12:34 AM, Ben Hutchings wrote:
...
[Nice info on stable maintainers, thanks.]
...
> Given that aoe is basically unchanged between Linux 2.6.32 and 3.6 I
> agree that the one patch should be sufficient.  However your previous
> patch was lacking a signoff or much of a commit message, so please do
> re-post it with those.  The commit message should include a reference to
> the corresponding mainline commit as you identified above.

OK.  Got it:

  [PATCH <= 3.6.y] aoe: do not call bdi_init after blk_alloc_queue
  http://thread.gmane.org/gmane.linux.kernel.stable/38957

That particular change (for <= 3.6.y)  is not derived from the mainline 
commit you mention, but the other patch for 3.7.y is, and I included a 
reference to the mainline commit in the changelog message for the 
3.7.y fix.

  [PATCH 3.7.y] aoe: merge 0a41409c5180 to avoid list corruption from extra bdi_init
  http://thread.gmane.org/gmane.linux.kernel.stable/38909

-- 
  Ed Cashin
  ecashin@coraid.com


