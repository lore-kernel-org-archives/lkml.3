Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbbAEUgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:36:51 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:35845 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbAEUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:36:49 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21674.62940.651019.548138@gargle.gargle.HOWL>
Date: Mon, 5 Jan 2015 21:36:44 +0100
To: Tony Luck <tony.luck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, mikpelinux@gmail.com,
        Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64\@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: status of ia64 / hpsim
In-Reply-To: <CA+8MBbJgXAW5pgVk2zshR-09gDNXPDa__c+g5yxTt4wUrJGJ2Q@mail.gmail.com>
References: <20141230155057.GA23826@infradead.org>
	<CA+8MBbJgXAW5pgVk2zshR-09gDNXPDa__c+g5yxTt4wUrJGJ2Q@mail.gmail.com>
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck writes:
 > On Tue, Dec 30, 2014 at 7:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
 > > IS the ia64 hpsim architecture still in use?  I noticed it because it
 > > has a fairly rudimentary SCSI driver under arch/ia64, which doesn't
 > > look very maintained.
 > 
 > Mikael was doing something with hpsim on the ski simulator back in Jan'14. Was
 > that something real, or just playing because it was there?

I was trying to set up an emulated platform for continuous GCC bootstrap and
regression testsuite runs, but something broke the ia64 kernel causing EXT4
file system errors in the emulated platform, so I had to scrap that idea.

I tried various ia64 kernel versions, compiling the ia64 kernel with older
GCCs, and compiling SKI with older host (x86_64) GCCs, but nothing worked.
With no known-good starting point there was no reasonable way for me to
debug the problem.

/Mikael
