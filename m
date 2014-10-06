Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaJFT24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:28:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJFT2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:28:55 -0400
Message-ID: <1412623718.32313.60.camel@smoke>
Subject: Re: [PATCH 1/5] kexec: Fix make headers_check
From: Geoff Levand <geoff@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kexec@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>
Date: Mon, 06 Oct 2014 12:28:38 -0700
In-Reply-To: <1412619708.14236.2.camel@x220>
References: <cover.1408731991.git.geoff@infradead.org>
	 <115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org>
	 <20140825172234.GD14379@redhat.com> <1409402838.21896.99.camel@x220>
	 <1412604734.4054.72.camel@x220> <1412616877.32313.55.camel@smoke>
	 <1412619708.14236.2.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 20:21 +0200, Paul Bolle wrote:
> On Mon, 2014-10-06 at 10:34 -0700, Geoff Levand wrote:
> > On Mon, 2014-10-06 at 16:12 +0200, Paul Bolle wrote:
> > > It seems not much happened after I added my Acked-by. I assume you still
> > > want to get this merged. Is that correct?
> > 
> > Yes, I think we concluded there are no real users of this kexec_load()
> > ptototype, and so it can be removed.
> 
> What would be the quickest way to get this finally resolved? Who's in
> charge of this stuff? Would resending your patch, with my Ack added,
> speed up things? The vain side of my personality does think it would
> help.

I'll prepare a V2 set of the this series with the various acks and ask
Andrew to merge it.

-Geoff


