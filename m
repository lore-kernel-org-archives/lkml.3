Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaLEWbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:31:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLEWbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:31:36 -0500
Date: Fri, 5 Dec 2014 14:31:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Message-Id: <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
	<CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
	<35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014 18:22:33 +0800 "Wang, Yalin" <Yalin.Wang@sonymobile.com> wrote:

> > -----Original Message-----
> > From: Konstantin Khlebnikov [mailto:koct9i@gmail.com]
> > Sent: Friday, December 05, 2014 5:21 PM
> > To: Wang, Yalin
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; linux-arm-
> > kernel@lists.infradead.org; akpm@linux-foundation.org; n-
> > horiguchi@ah.jp.nec.com
> > Subject: Re: [RFC] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
> > 
> > On Fri, Dec 5, 2014 at 11:57 AM, Wang, Yalin <Yalin.Wang@sonymobile.com>
> > wrote:
> > > This patch add KPF_ZERO_PAGE flag for zero_page, so that userspace
> > > process can notice zero_page from /proc/kpageflags, and then do memory
> > > analysis more accurately.
> > 
> > It would be nice to mark also huge_zero_page. See (completely
> > untested) patch in attachment.
> > 
> Got it,
> Thanks for your patch.

Documentation/vm/pagemap.txt will need updating please.
