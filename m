Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaGQMsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:48:13 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:63942 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbaGQMsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:48:12 -0400
Date: Thu, 17 Jul 2014 08:48:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] devres: Add devm_kasprintf and devm_kvasprintf API
Message-ID: <20140717124808.GA21649@htj.dyndns.org>
References: <20140716205752.GA3109@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716205752.GA3109@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:27:52AM +0530, Himangi Saraogi wrote:
> devm_kasprintf() and devm_kvasprintf() are the managed counterparts
> for kasprintf() and kvasprintf().
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
