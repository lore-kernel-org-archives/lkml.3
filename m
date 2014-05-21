Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaEUBxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:53:41 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43051 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaEUBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140519212416.GA14152@node.dhcp.inet.fi>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<CALN0BAu0E9r0hdy_Vc6GoKiXXk_w0vetRdumW-3eFFzOPqsFSQ@mail.gmail.com>
	<20140519212416.GA14152@node.dhcp.inet.fi>
Date: Tue, 20 May 2014 21:53:36 -0400
Message-ID: <CALN0BAuzw74rLwrF+FvDWHHc+rtoF8+DAZwEOXzoWsVeS=GbCg@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Kenny Simpson <theonetruekenny@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ouch... hope they don't try to run that code on anything newer then :(
 Will let them know.

-Kenny


On Mon, May 19, 2014 at 5:24 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Mon, May 19, 2014 at 01:34:05PM -0400, Kenny Simpson wrote:
>> For the other cases I had used the remapping to have more of a sliding
>> window over a disk-backed file where I also was using aliasing to
>> eliminate the corner cases of hitting the end of a window and needing
>> to split records due to crossing boundaries, etc..
>
> Disk backed files are not supported by remap_file_pages() since 2007.
> See commit 3ee6dafc677a.
>
> --
>  Kirill A. Shutemov
