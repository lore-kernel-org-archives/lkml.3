Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3JWNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:09:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3JWNJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:09:56 -0400
Date: Wed, 23 Oct 2013 15:09:53 +0200
From: Michal Marek <mmarek@suse.cz>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org
Subject: Re: [PATCH][resend]scripts/tags.sh: Increase identifier list
Message-ID: <20131023130953.GA21936@sepie.suse.cz>
References: <47921380795212@web26m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47921380795212@web26m.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:13:32PM +0400, Kirill Tkhai wrote:
> Add		__maybe_unused
> 		__always_unused
> 		__cacheline_aligned
> 		__cacheline_aligned_in_smp
> 		ACPI_EXPORT_SYMBOL
> to the list.
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Michal Marek <mmarek@suse.cz>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  scripts/tags.sh |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

I took the patch from the mm tree and applied to kbuild.git#misc now.
Sorry for the delay.

Michal
