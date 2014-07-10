Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaGJOR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:17:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43655 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaGJOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:17:26 -0400
Date: Thu, 10 Jul 2014 16:17:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-ID: <20140710141723.GS18735@two.firstfloor.org>
References: <53B667F9.90306@bull.net>
 <87y4w6sbp7.fsf@tassilo.jf.intel.com>
 <53BA772C.6040506@bull.net>
 <20140707163003.GA18735@two.firstfloor.org>
 <20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org>
 <20140707224634.GE18735@two.firstfloor.org>
 <53BB8F7C.1060505@bull.net>
 <53BE37E5.4030407@bull.net>
 <20140710000745.37be4400.akpm@linux-foundation.org>
 <53BE40E3.6000101@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BE40E3.6000101@bull.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:29:39AM +0200, Sebastien Buisson wrote:
> 
> Le 10/07/2014 09:07, Andrew Morton a écrit :
> >This hardwires 16 if ext4&quota and 8 otherwise.  There's no way for
> >anyone to alter this decision if they think it will be helpful (or
> >harmful) in their setup.
> 
> In fact I do not know how to let experienced people alter the value
> without confusing the others with yet another obscure config option
> (Andi's comment). I would welcome any suggestion to achieve this.

I don't think we should generally expose it.

If someone really wants to experiment they can change the source.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
