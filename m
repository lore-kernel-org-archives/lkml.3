Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3JHD25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:28:57 -0400
Received: from ozlabs.org ([203.10.76.45]:43431 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3JHD24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:28:56 -0400
Message-ID: <1381202935.25887.4.camel@concordia>
Subject: Re: [PATCH 5/9][v5] powerpc: implement is_instr_load_store().
From: Michael Ellerman <michael@ellerman.id.au>
To: Tom Musta <tommusta@gmail.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 14:28:55 +1100
In-Reply-To: <524DCAE6.5090601@gmail.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
	 <1380672911-12812-6-git-send-email-sukadev@linux.vnet.ibm.com>
	 <20131003053519.GC17237@concordia> <20131003190325.GB21561@us.ibm.com>
	 <524DCAE6.5090601@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 14:52 -0500, Tom Musta wrote:
> On 10/3/2013 2:03 PM, Sukadev Bhattiprolu wrote:
> > Michael Ellerman [michael@ellerman.id.au] wrote:
> <snip>
> > |
> > |         if (lower == 6)
> > |             if (upper <= 1)
> > |                 return true;
> > |             return false;
> > v

> Note that this case covers the lvsl/lvsr instructions, which, despite their
> names are not actually loads.  So you could eliminate this check and do
> just a little bit better.

Yes you're right Tom, thanks for checking.

I saw "Load" in the name and that was good enough for me :)

cheers



