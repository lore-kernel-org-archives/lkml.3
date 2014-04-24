Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaDXSSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:18:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbaDXSST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:18:19 -0400
Date: Thu, 24 Apr 2014 11:18:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 5/7] swap: Use bdev_read_page() / bdev_write_page()
Message-Id: <20140424111817.9cc62b2ff1e368c5cf27d262@linux-foundation.org>
In-Reply-To: <9fb0b4031b0fba312963a7cc21bf258d944cddcf.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
	<9fb0b4031b0fba312963a7cc21bf258d944cddcf.1397429628.git.matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 18:59:54 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

>  mm/page_io.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)

Some changelog here would be nice.  What were the reasons for the
change?  Any observable performance changes?

