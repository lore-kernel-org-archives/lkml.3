Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbaGVTeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:34:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43891 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756555AbaGVTeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:34:00 -0400
Date: Tue, 22 Jul 2014 15:33:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Levente Kurusa <lkurusa@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
Message-ID: <20140722193350.GA486@home.goodmis.org>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
 <874my98p6u.fsf@nemi.mork.no>
 <CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
 <CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
 <CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com>
 <CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:25:24PM -0400, Nick Krause wrote:
> 
> I understand what your saying and I should have searched for Page shift.
> In addition I am already got commits in the kernel for fix mes so I feel
> that your comment on fix mes is incorrect.

After seeing your other solutions to "fix mes" around the kernel, I now have to
investigate the patches that were accepted, and see if they did not cause
any new bugs. If any of them do, I will ask to have all your patches reverted.

You are not helping. You are actually doing quite the opposite. Who do you work
for? Microsoft or Apple?

-- Steve

