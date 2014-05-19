Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaESV1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:27:18 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:46495 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaESV1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:27:16 -0400
Date: Tue, 20 May 2014 00:24:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Kenny Simpson <theonetruekenny@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Subject: Re: remap_file_pages() use
Message-ID: <20140519212416.GA14152@node.dhcp.inet.fi>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <CALN0BAu0E9r0hdy_Vc6GoKiXXk_w0vetRdumW-3eFFzOPqsFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALN0BAu0E9r0hdy_Vc6GoKiXXk_w0vetRdumW-3eFFzOPqsFSQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 01:34:05PM -0400, Kenny Simpson wrote:
> For the other cases I had used the remapping to have more of a sliding
> window over a disk-backed file where I also was using aliasing to
> eliminate the corner cases of hitting the end of a window and needing
> to split records due to crossing boundaries, etc..

Disk backed files are not supported by remap_file_pages() since 2007.
See commit 3ee6dafc677a.

-- 
 Kirill A. Shutemov
