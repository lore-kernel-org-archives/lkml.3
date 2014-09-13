Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaIMPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:25:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaIMPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:25:27 -0400
Date: Sat, 13 Sep 2014 08:24:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.16.y: acpi-battery fixes
Message-ID: <20140913152438.GA3072@kroah.com>
References: <CA+icZUW8vHj9_L-4WD0FR6mUTWW621T5O-Cd=fSJ_UoPX0BQUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUW8vHj9_L-4WD0FR6mUTWW621T5O-Cd=fSJ_UoPX0BQUg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 02:52:52PM +0200, Sedat Dilek wrote:
> Hi Greg,
> 
> I hoped the acpi-fixes from [1] (especially [2]) would fix my shown
> "85% battery available", but a Ubuntu/trusty kernel reports the same
> (battery defect?).
> The 2nd revert is applicable, the 1st not, both are labeled with 3.16+.
> 
> Wanna pick them or have it already on your to-do?
> 
> Thanks.
> 
> Regards,
> - Sedat -
> 
> [1] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=acpi-battery
> [2] http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=acpi-battery&id=508b3c677601797f2d51df3df5caa436dd235cb9

First off, stable kernel questions should go to stable@vger.kernel.org,
not just to me.

Secondly, I don't understand what you are asking here.  What exact fix
in Linus's tree do you want to see in a stable backport that I haven't
taken already?  I've queued up a number of ACPI fixes for 3.16.3, are
they not sufficient?

thanks,

greg k-h
