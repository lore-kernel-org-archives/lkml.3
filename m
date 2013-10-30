Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3J3Puy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:50:54 -0400
Received: from fifo99.com ([67.223.236.141]:56867 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3J3Puw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:50:52 -0400
Date: Wed, 30 Oct 2013 08:50:32 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM: msm: Remove 8x50 support
Message-ID: <20131030155032.GA5822@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-5-git-send-email-davidb@codeaurora.org>
 <20131029211901.GB16284@fifo99.com>
 <201310301430.24115.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310301430.24115.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:30:23PM +0100, Arnd Bergmann wrote:
> On Tuesday 29 October 2013, Daniel Walker wrote:
> > Isn't this the Nexus one platform ? Same as the last one , why don't you
> > just update it to use the device tree? This doesn't seem like it would
> > be all that difficult. 
> 
> Please don't top-post.

Seriously ? I was responding to the whole comment, don't be so pedantic
..

> 
> > On Mon, Oct 28, 2013 at 01:43:26PM -0700, David Brown wrote:
> > > 
> > > This code has not been converted to device tree, and is hindering
> > > support for the multi-platform kernel on ARM.  If someone wishes to
> > > continue support for this target, patches that provide devicetree and
> > > multi-platform support can start by re-adding these files.
> 
>     ^ Here is your answer.
> 
> 
> While I'd definitely love to see support for the Nexus One upstream,
> it is evident that nobody has been working on this for a long time.

I have a device with this chip in it .. I would like that device not to
disappear from Linux .. Doing this puts an un-do burden on users
who would like to see this support go in, but if it's removed like this
that will never happen. No one has an much information on these chips as
Qualcomm .. It's not realistic that any user would be able to do a
lot without their support.. By allowing them to remove code for these
device it effectively ends and chance of them have more code support added..
Yet the devices exist in mass amounts.

To be honest your not an MSM maintainer, are there are political issue
related to this.. This isn't particularly technical because converting
these relatively simple platform to the device tree shouldn't be all
that difficult. To me Your involvement is puzzling .. Myself and my
co-maintainers need to be the ones discussing this..

G1 code is also getting removed in this series, and the code for this
creates a usable device .. The problem here is that you really can't
start randomly removing support for platforms that people have and want
them to continue working. We have a process for that, and typically user
objections weight heavily in that process (read, feature-removal-schedule.txt)

Daniel
