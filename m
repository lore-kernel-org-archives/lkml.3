Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaIRSTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:19:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:36081 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbaIRSTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:19:30 -0400
Date: Thu, 18 Sep 2014 14:19:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG in ext4_setattr
Message-ID: <20140918181926.GA19520@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pranith Kumar <bobby.prani@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <CAJhHMCBhN7iVOBVJmoFBiLVurs2uncnJ57p5RBeC5z=_kSgUfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBhN7iVOBVJmoFBiLVurs2uncnJ57p5RBeC5z=_kSgUfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:01:00PM -0400, Pranith Kumar wrote:
> 
> The following splat occurs in the latest rc5+ kernel. I am not sure
> this is enough information. Please let me know what options to enable
> to get more meaningful info.

This is a PowerMac, apparently.  I don't know why we can get symbol
information for at least part of the stack, but not for the fault
location.

Is this repeatable?  If so, the best way to go forward is a bisection
search.

							- Ted
