Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaFMOob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:44:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaFMOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:44:29 -0400
Date: Fri, 13 Jun 2014 10:44:05 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Tom Herbert <therbert@google.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] Networking
Message-ID: <20140613144405.GA7122@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Tom Herbert <therbert@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20140612.121445.484288603919840829.davem@davemloft.net>
 <CA+55aFy=CThoSKAJ6J3Jt-SJDkiGzwg=5tdF7_g+vyTEoPFzMQ@mail.gmail.com>
 <1402642787.4478.5.camel@jlt4.sipsolutions.net>
 <CA+55aFw-UTwA0+dmCnqwjSEW244s0CLK4V5vuh2TmLku7A0mDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw-UTwA0+dmCnqwjSEW244s0CLK4V5vuh2TmLku7A0mDQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 07:28:33AM -0700, Linus Torvalds wrote:
 > On Thu, Jun 12, 2014 at 11:59 PM, Johannes Berg
 > <johannes@sipsolutions.net> wrote:
 > >
 > > is to be believed, then I'm not sure why you think iwlwifi is involved
 > > though.
 > 
 > Mainly just because I don't see the issue on my desktop, and iwlwifi
 > is the only network device (apart from looback) on my laptop. And it
 > does say "hw checksum", so that made me think it's the driver.
 > 
 > But:
 > 
 > > If it's iwlwifi, then maybe that commit broke something with devices
 > > that don't support checksumming?
 > 
 > that sounds quite possible.

I see it on my router with two r8169 cards too.
That does seem to support hw csum, though only on jumbo frames maybe?


	Dave

