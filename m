Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaBDPDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:03:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:03:46 -0500
Message-ID: <1391526218.5532.33.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.9-rt13
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Tue, 04 Feb 2014 16:03:38 +0100
In-Reply-To: <20140203194841.GA17108@linutronix.de>
References: <20140203194841.GA17108@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:x8MXykSjqlxhlW0i68rHSpTbD76/Ehee8G0GL5rgpAS
 fLkvxLzIJf/vG9R2a9HjPcc4+KVOduADLBJZaKL8CAV0gHj+GR
 iR2wwhq0AlME05NL3nIMsEhQ3tClhow8JY/7Z7oD5rvOiGm9b6
 1wAFfzDonMwXMhl4Je+4fZ5Lg2MABf/jsOc/QKRRp8ufnV50jh
 MKo3Fvj4dcgetC7IzWCO3CXBCOVqEqXIWLQbfoLBvCe652H5Il
 613UVz92cNlDMa1v2mNdqkkkp5e2QfOdkZkLUoEshbxy32GeIb
 o243+E7j6pmpFRD0cywgp2d+H6pdld7/mt+U0fdlSB+lPHKrQo
 fd6TP6P+kq6OeQ3EU4N6t6qjeRriauKGumfBqZDFxCD7bxJZij
 l1pqLnhLbHyig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 20:48 +0100, Sebastian Andrzej Siewior wrote:

> Known issues:

> Mike said that it caused two of his 64 CPUs to spin for five minutes
>         doing nothing. Therefore it is disabled in the queue. Everyone
>         who wants test it may do so :)

I put rt13 on an 8 socket Opetron (48 core) box, with patch enabled.  It
box did NOT reproduce the hangs the 8 socket (1 node, bleh) DL980 did.

Nor did it explode running hotplug stress, but then it deadlocks before
BOOM would have happened on the DL980.  kdump isn't working properly on
this box (not an rt issue, userspace), so..

-Mike

