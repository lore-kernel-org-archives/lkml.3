Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaLBKch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:32:37 -0500
Received: from hofr.at ([212.69.189.236]:54585 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaLBKce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:32:34 -0500
Date: Tue, 2 Dec 2014 11:32:31 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] limit _shipped to c h and S files
Message-ID: <20141202103231.GA30141@opentech.at>
References: <20141202091621.GE13909@opentech.at> <547D924A.2010205@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547D924A.2010205@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2014, Michal Marek wrote:

> Dne 2.12.2014 v 10:16 Nicholas Mc Guire napsal(a):
> > 
> > limit _shipped to c h and S files
> > 
> > _shipped targets are intended for generated source files which should
> > not permit .o binary blobs which is currently the case. This patch
> > simply restricts _shipped targets to .c, .h and .S files.
> 
> 
> IMO this just adds lines of code without any obvious advantage. The
> other patches in the series are fine.
>

The idea simply was to make the behavior of kbuild match the
documented intent of _shipped files. Technically it is not needed,
its an attempt to raises the barrier a bit for including actual
binary blobs. 

thx!
hofrat
