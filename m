Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3FVKcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 06:32:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3FVKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 06:32:11 -0400
Date: Sat, 22 Jun 2013 03:31:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Colin Cross <ccross@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: RFC: named anonymous vmas
Message-ID: <20130622103158.GA16304@infradead.org>
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 04:42:41PM -0700, Colin Cross wrote:
> ranges, which John Stultz has been implementing.  The second is
> anonymous shareable memory without having a world-writable tmpfs that
> untrusted apps could fill with files.

I still haven't seen any explanation of what ashmem buys over a shared
mmap of /dev/zero in that respect, btw.

