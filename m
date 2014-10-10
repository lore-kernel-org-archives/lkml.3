Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaJJLmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:42:44 -0400
Received: from plane.gmane.org ([80.91.229.3]:53107 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaJJLmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:42:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 3.12 00/96] 3.12.30-stable review
Date: Fri, 10 Oct 2014 11:42:28 +0000 (UTC)
Message-ID: <pan.2014.10.10.11.42.28@googlemail.com>
References: <cover.1412147522.git.jslaby@suse.cz>
	<CAJ75kXb-mmrW9n51O19rM4xz1i_qTBjzAkOzfY5brWW4TEig1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pd953ec9a.dip0.t-ipconnect.de
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014 09:32:45 +0200, William Dauchy wrote:

> Hi stable release team,
> 
> On Wed, Oct 1, 2014 at 10:57 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> This one is special. First, it is rounded (30). Second, most of the
>> patches are performance improvements. They are coming from SUSE
>> Enterprise Linux and all are backed by proper testing and performance
>> measurements. All this patchset was prepared and sent by Mel Gorman
>> with a support of other patchers from SUSE. Thanks to all of them.
> 
> I'm just wondering if 3.10.x and 3.14.x are going to benefit from
> these performance improvement patches as well.

This set of patches was awesome but also pretty large and touched some
nontrivial parts, so it's not just a simple matter of merging them
wholesale.

I merged a handful of these patches to my own private 3.14.x tree where
they work wonderfully, and some have already appeared in the latest
stable-3.14.21. Greg also said that he has more in the queue. :)

The one I have so far punted on due to the filesystem dependencies is
2457aec63745e235bcafb7ef312b182d8682f0fc aka: "mm: non-atomically mark
page accessed during page cache allocation where possible" - that would
be really nice to have.

-h

