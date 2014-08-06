Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaHFJ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:56:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.230]:53836 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbaHFJ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:56:15 -0400
Date: Wed, 6 Aug 2014 12:55:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] fs/proc/task_mmu.c: unify/simplify do_maps_open()
 and numa_maps_open()
Message-ID: <20140806095503.GB30508@node.dhcp.inet.fi>
References: <20140805194627.GA30693@redhat.com>
 <20140805194648.GA30718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194648.GA30718@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:46:48PM +0200, Oleg Nesterov wrote:
> do_maps_open() and numa_maps_open() are overcomplicated, they could
> use __seq_open_private(). Plus they do the same, just sizeof(*priv)
> differs.
> 
> Change them to use a new simple helper, proc_maps_open(ops, psize).
> This simplifies the code and allows us to do the next changes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
