Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3DKUZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:25:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3DKUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:49 -0400
Date: Thu, 11 Apr 2013 13:25:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, koverstreet@google.com, bcrl@kvack.org,
        schwidefsky@de.ibm.com, kirill.shutemov@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] aio: convert the ioctx list to radix tree
Message-Id: <20130411132547.cd0df05abeea6a7f49646b0c@linux-foundation.org>
In-Reply-To: <1364995248-11028-1-git-send-email-octavian.purdila@intel.com>
References: <1364995248-11028-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Apr 2013 16:20:48 +0300 Octavian Purdila <octavian.purdila@intel.com> wrote:

> This patchs converts the ioctx list to a radix tree.

This looks rather nice, but unfortunately all the pending aio work in
-mm/linux-next totally messes it up.

Could you please redo and retest it over the pending work?  Perhaps
after 3.10-rc1 would be a convenient time.

