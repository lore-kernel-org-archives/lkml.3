Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbaDJIOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:14:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36248 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJIOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:14:51 -0400
Date: Thu, 10 Apr 2014 10:14:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410081445.GK10526@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397108579.2586.15.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:42:59PM -0700, Jason Low wrote:
> +#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_DEBUG_LOCK_ALLOC)

DEBUG_LOCK_ALLOC always implies DEBUG_MUTEXES, see lib/Kconfig.debug
