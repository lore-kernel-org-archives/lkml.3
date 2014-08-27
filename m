Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaH0Anf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbaH0Ane (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:43:34 -0400
Date: Tue, 26 Aug 2014 20:42:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kexec: minor fixups and enhancements
Message-ID: <20140827004241.GA25728@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
 <20140825165916.GC14379@redhat.com>
 <1409099608.21254.16.camel@smoke>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409099608.21254.16.camel@smoke>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 05:33:28PM -0700, Geoff Levand wrote:
> Hi Vivek,
> 
> On Mon, 2014-08-25 at 12:59 -0400, Vivek Goyal wrote:
> > Does arm64 has secureboot? If yes, then it might make sense to
> > enable the new syscall kexec_file_load() on arm64 instead of trying
> > to make old syscall work first.
> 
> Yes, arm64 should support secureboot, but I have not looked into it.
> 
> When do you expect syscall kexec_file_load to get merged?  I won't wait
> until then to push my current kexec work.

It got merged in 3.17-rc1

Thanks
Vivek
