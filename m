Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaIWBMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:12:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaIWBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:12:20 -0400
Date: Mon, 22 Sep 2014 18:12:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        mhocko@suse.cz
Subject: Re: mmotm 2014-09-22-16-57 uploaded
Message-Id: <20140922181217.bb56b74d.akpm@linux-foundation.org>
In-Reply-To: <20140923103925.08b35d84@canb.auug.org.au>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
	<20140923103925.08b35d84@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 10:39:25 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > The file broken-out.tar.gz contains two datestamp files: .DATE and
> > .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> > followed by the base kernel version against which this patch series is to
> > be applied.
> 
> This tar file is no longer expanded into a broken-out directory?

ssh connections to ozlabs.org were intermittently timing out,
producing a partial result.  Then they stopped altogether while I was
poking at it.

Maybe it will be feeling better tomorrow.
