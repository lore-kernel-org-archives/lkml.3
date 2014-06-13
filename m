Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaFMSZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:25:50 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:48123 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaFMSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:25:49 -0400
Date: Fri, 13 Jun 2014 14:25:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
Message-ID: <20140613182538.GB3723@htj.dyndns.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
 <1402590209-31610-6-git-send-email-tj@kernel.org>
 <alpine.DEB.2.10.1406131215330.1717@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406131215330.1717@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:16:27PM -0500, Christoph Lameter wrote:
> On Thu, 12 Jun 2014, Tejun Heo wrote:
> 
> > +#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
> > +#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
> 
> At the conclusion of the current &get_cpu_var patchset these two
> definitions are scheduled to be removed.

Yeah, dropping that part isn't difficult.  Where's the &get_cpu_var
patchset now?  Is it gonna make it into v3.16-rc1?

Thanks.

-- 
tejun
