Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaFRSPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:15:09 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:47825 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaFRSPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:15:05 -0400
Message-ID: <1403115292.3787.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFT 2/2] printk: allow increasing the ring buffer depending on
 the number of CPUs
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 18 Jun 2014 11:14:52 -0700
In-Reply-To: <1403115072.3787.3.camel@buesod1.americas.hpqcorp.net>
References: <1403090065-13879-1-git-send-email-mcgrof@do-not-panic.com>
	 <1403090065-13879-2-git-send-email-mcgrof@do-not-panic.com>
	 <1403115072.3787.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 11:11 -0700, Davidlohr Bueso wrote:
> Also, while at it, how about making it
> easier for users and also print the total size (num_possible_cpus() *
> cpu_extra)?

Sorry, I meant the individual contribution of each CPU, not the total
which you already have.

