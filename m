Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaHPM7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 08:59:39 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:46951 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaHPM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 08:59:37 -0400
Date: Sat, 16 Aug 2014 08:59:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Honggang Li <enjoymindful@gmail.com>
Cc: cl@linux-foundation.org, linux-mm@kvack.org,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Free percpu allocation info for uniprocessor system
Message-ID: <20140816125934.GG9305@htj.dyndns.org>
References: <1407850575-18794-1-git-send-email-enjoymindful@gmail.com>
 <1407850575-18794-2-git-send-email-enjoymindful@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407850575-18794-2-git-send-email-enjoymindful@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 09:36:15PM +0800, Honggang Li wrote:
> Currently, only SMP system free the percpu allocation info.
> Uniprocessor system should free it too. For example, one x86 UML
> virtual machine with 256MB memory, UML kernel wastes one page memory.
> 
> Signed-off-by: Honggang Li <enjoymindful@gmail.com>

Applied to percpu/for-3.17-fixes w/ stable cc'd.

Thanks.

-- 
tejun
