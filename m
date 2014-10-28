Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJ1Syu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:54:50 -0400
Received: from hydra.tuxags.com ([64.13.172.54]:45288 "EHLO mail.tuxags.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJ1Sys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:54:48 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 14:54:48 EDT
Date: Tue, 28 Oct 2014 11:47:19 -0700
From: Matt Mullins <mmullins@mmlx.us>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Stable <stable@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v3 1/4] mm/balloon_compaction: redesign ballooned pages
 management
Message-ID: <20141028184719.GB29098@hydra.tuxags.com>
Mail-Followup-To: Konstantin Khlebnikov <koct9i@gmail.com>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Rafael Aquini <aquini@redhat.com>, Stable <stable@vger.kernel.org>,
	Sasha Levin <sasha.levin@oracle.com>
References: <20140927183403.13738.22121.stgit@zurg>
 <20140927191515.13738.18027.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140927191515.13738.18027.stgit@zurg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 11:15:16PM +0400, Konstantin Khlebnikov wrote:
> This patch fixes all of them.

It seems to have rendered virtio_balloon completely ineffective without
CONFIG_COMPACTION and CONFIG_BALLOON_COMPACTION, even for the case that I'm
expanding the memory available to my VM.

Was this intended?  Should Kconfig be updated so that VIRTIO_BALLOON depends on
BALLOON_COMPACTION now?
