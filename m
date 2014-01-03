Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaACU3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:29:25 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48885 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaACU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:29:24 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 3 Jan 2014 12:29:15 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Makefile: Build with -Werror=date-time if the
 compiler supports it
Message-ID: <20140103202915.GB12111@leaf>
References: <cover.1387833347.git.josh@joshtriplett.org>
 <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org>
 <52C6E814.7090301@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C6E814.7090301@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 05:40:52PM +0100, Michal Marek wrote:
> On 2013-12-23 22:56, Josh Triplett wrote:
> > GCC 4.9 and newer have a new warning -Wdate-time, which warns on any use
> > of __DATE__, __TIME__, or __TIMESTAMP__, which would make the build
> > non-deterministic.  Now that the kernel does not use any of those
> > macros, turn on -Werror=date-time if available, to keep it that way.
> 
> Nice, I didn't know about -Wdate-time. Do you want me to merge the
> entire series, or do you want individual maintainers merge the patches?
> In the latter case, I'd wait with applying 7/7 in order not to break the
> build. At any rate, you can add
> 
> Acked-by: Michal Marek <mmarek@suse.cz>

Please feel free to take the entire series through your tree; I received
some maintainer acks, but no indications that the patches are going
through their trees.

Patch 1 should have:
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

and patch 3 should have:
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,
Josh Triplett
