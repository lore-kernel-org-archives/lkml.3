Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaCXMuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:50:13 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:59317 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaCXMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:50:12 -0400
Date: Mon, 24 Mar 2014 08:50:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: akpm@linux-foundation.org, jlayton@redhat.com, jdelvare@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: Use RCU_INIT_POINTER(x, NULL) in idr.c
Message-ID: <20140324125008.GB29892@mtj.dyndns.org>
References: <1395601808-12365-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395601808-12365-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 12:40:08AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
