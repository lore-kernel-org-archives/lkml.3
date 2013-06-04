Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3FDOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:53:29 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:42019 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3FDOx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:53:27 -0400
X-ASG-Debug-ID: 1370357604-03d6a5737c343b00001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130604144856.GA12302@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org> <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org> <20130604144856.GA12302@infradead.org>
Message-ID: <20130604145322.4088.78915@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Date: Tue, 4 Jun 2013 10:53:22 -0400
X-ASG-Orig-Subj: Re: [PATCH 0/2] introduce list_for_each_entry_del
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1370357604
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.132943
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Hellwig (2013-06-04 10:48:56)
> On Mon, Jun 03, 2013 at 03:55:55PM -0400, J??rn Engel wrote:
> > Actually, when I compare the two invocations, I prefer the
> > list_for_each_entry_del() variant over list_pop_entry().
> > 
> >         while ((ref = list_pop_entry(&prefs, struct __prelim_ref, list))) {
> >         list_for_each_entry_del(ref, &prefs, list) {
> > 
> > Christoph?
> 
> I really don't like something that looks like an iterator (*for_each*)
> to modify a list.  Maybe it's just me, so I'd love to hear others chime
> in.

Have to agree with Christoph.  I just couldn't put my finger on why I
didn't like it until I saw the list_pop_entry suggestion.

-chris

