Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbaGCNUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:20:24 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:38474 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbaGCNUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:20:21 -0400
Date: Thu, 3 Jul 2014 08:19:27 -0500
From: scameron@beardog.cce.hp.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] [SCSI] hpsa: fix non-x86 builds
Message-ID: <20140703131927.GG9147@beardog.cce.hp.com>
References: <6003317.KPlAy1USkq@wuerfel> <20140626143445.GO25166@beardog.cce.hp.com> <20140703084348.GA16881@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703084348.GA16881@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 01:43:48AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 26, 2014 at 09:34:45AM -0500, scameron@beardog.cce.hp.com wrote:
> > Thanks.
> 
> Do you plan to include this with the next hpsa update, or should I take
> this as an ACK and apply it?

Take it as an ACK.  I should have been clearer.

-- steve

