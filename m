Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899AbaGCIq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:46:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbaGCIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:54 -0400
Date: Thu, 3 Jul 2014 01:43:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: scameron@beardog.cce.hp.com
Cc: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [SCSI] hpsa: fix non-x86 builds
Message-ID: <20140703084348.GA16881@infradead.org>
References: <6003317.KPlAy1USkq@wuerfel>
 <20140626143445.GO25166@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626143445.GO25166@beardog.cce.hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:34:45AM -0500, scameron@beardog.cce.hp.com wrote:
> Thanks.

Do you plan to include this with the next hpsa update, or should I take
this as an ACK and apply it?

