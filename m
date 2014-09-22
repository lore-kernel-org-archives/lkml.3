Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaIVECt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:02:49 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:65079 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaIVECs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:02:48 -0400
Date: Mon, 22 Sep 2014 00:02:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Honggang Li <enjoymindful@gmail.com>
Subject: Re: [PATCH] Revert "percpu: free percpu allocation info for
 uniprocessor system"
Message-ID: <20140922040245.GF23583@htj.dyndns.org>
References: <1411337093-683-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411337093-683-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 03:04:53PM -0700, Guenter Roeck wrote:
> This reverts commit 3189eddbcafc ("percpu: free percpu allocation info for
> uniprocessor system").
> 
> The commit causes a hang with a crisv32 image. This may be an architecture
> problem, but at least for now the revert is necessary to be able to boot a
> crisv32 image.
> 
> Fixes: 3189eddbcafc ("percpu: free percpu allocation info for uniprocessor system")
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Honggang Li <enjoymindful@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied to percpu/for-3.18.

Thanks.

-- 
tejun
