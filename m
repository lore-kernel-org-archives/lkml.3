Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaFMNAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:00:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaFMNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:00:35 -0400
Date: Fri, 13 Jun 2014 14:00:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm/fs: gpf when shrinking slab
Message-ID: <20140613130026.GF18016@ZenIV.linux.org.uk>
References: <539AF460.4000400@oracle.com>
 <539AF4A6.9060707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AF4A6.9060707@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:55:02AM -0400, Sasha Levin wrote:
> Hand too fast on the trigger... sorry.
> 
> It happened while fuzzing inside a KVM tools guest on the latest -next kernel. Seems
> to be pretty difficult to reproduce.

Does that kernel contain c2338f?
