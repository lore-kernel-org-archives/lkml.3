Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaEUOcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:32:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaEUOce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:32:34 -0400
Date: Wed, 21 May 2014 07:32:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>
Subject: Re: /proc/stat vs. failed order-4 allocation
Message-ID: <20140521143229.GA32011@infradead.org>
References: <20140521122521.GB7471@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521122521.GB7471@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 02:25:21PM +0200, Heiko Carstens wrote:
> Hi all,
> 
> I'm just wondering why /proc/stat is a single_open() seq_file and not a
> regular seq_file with an iterator (say 48 online cpus for each iteration
> or something similar).

Probably because no one sent a patch for it. I'm pretty sure it used the
even more horrible old proc ops before and was converted in batch with
various other files.
