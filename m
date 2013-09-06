Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab3IFSH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:07:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47887 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3IFSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:07:56 -0400
Date: Fri, 6 Sep 2013 14:07:51 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, linux-arch@vger.kernel.org,
        arnd@arndb.de, mgahagan@redhat.com, agospoda@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2 4/4] kernel: add support for init_array constructors
Message-ID: <20130906180751.GD25882@merlin.infradead.org>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
 <1378305776-3644-5-git-send-email-fhrbata@redhat.com>
 <87vc2e66kr.fsf@rustcorp.com.au>
 <20130906175118.GB2332@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906175118.GB2332@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 07:51:18PM +0200, Frantisek Hrbata wrote:
> > > v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
> > >       .ctors or .init_array, but not both at the same time
> > >
> > > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> > 
> > Might be nice to document which gcc version changed this, so people can
> > choose whether to cherry-pick this change?
> 
> Thank you for pointing this out. As per gcc git this was introduced by commit
> ef1da80 and released in 4.7 version.
> 
> $ git describe --contains ef1da80
> gcc-4_7_0-release~4358
> 
> Do you want me to post v3 with this info included in the descrition?
> 

It actually depends on the combination of binutils/ld and gcc you use, not
simply which gcc version you use. :/

--Kyle
