Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3FQIzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:55:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FQIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:55:21 -0400
Date: Mon, 17 Jun 2013 09:55:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [iput] BUG: Bad page state in process rm pfn:0b0ce
Message-ID: <20130617085518.GG1875@suse.de>
References: <20130613102549.GD31394@localhost>
 <20130614091655.GD1875@suse.de>
 <20130615075623.GA2666@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130615075623.GA2666@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 03:56:23PM +0800, Fengguang Wu wrote:
> On Fri, Jun 14, 2013 at 10:16:55AM +0100, Mel Gorman wrote:
> > On Thu, Jun 13, 2013 at 06:25:49PM +0800, Fengguang Wu wrote:
> > > Greetings,
> > > 
> > > I got the below dmesg in linux-next and the first bad commit is
> > > 
> > 
> > Thanks Fengguang.
> > 
> > Can you try the following please? I do not see the same issue
> > unfortunately but I am the wrong type of unlucky here.
> 
> Mel, this reliably fixes the problem.
> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> 

Thanks very much. Patch is winging its way to Andrew now.

-- 
Mel Gorman
SUSE Labs
