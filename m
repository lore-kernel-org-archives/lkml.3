Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3JHEOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 00:14:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3JHEOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 00:14:05 -0400
Date: Mon, 7 Oct 2013 21:13:20 -0700
From: Greg KH <gregkh@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: torvalds@linux-foundation.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
Message-ID: <20131008041320.GA23838@kroah.com>
References: <20131007191835.GA28737@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007191835.GA28737@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:18:43PM -0700, Josh Triplett wrote:
> The 80-character limit is not a hard-and-fast rule, nor should it be
> applied blindly by people running checkpatch and fixing its warnings.
> Sometimes it's better to violate the 80-character "limit" in the name of
> readability, and when it isn't, it's often better to refactor into a
> function or otherwise restructure the code rather than just finding
> increasingly awkward places to break lines.
> 
> Thus, change checkpatch's LONG_LINE warning to a --strict CHK instead.
> Anyone wanting to use checkpatch to check for this can easily enough
> enable --strict or turn on LONG_LINE explicitly, but it shouldn't be
> part of the default warnings.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
