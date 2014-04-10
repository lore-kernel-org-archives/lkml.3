Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbaDJSzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:55:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55094 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161142AbaDJSzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:55:46 -0400
Date: Thu, 10 Apr 2014 13:42:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jason Low <jason.low2@hp.com>, "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410114258.GM10526@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
 <20140410091544.GA23433@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410091544.GA23433@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 12:15:44PM +0300, Kirill A. Shutemov wrote:
> I'm not able to trigger the lockdep report with the patch applied so far.

So what I've found it that the lockdep reports are valid; the only
difference is a lockup after the report or not.

So linus.git will hang after a lockdep splat, whereas the patched kernel
will continue after giving the exact same lockdep splat.


