Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaHFVmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:42:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaHFVmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:42:18 -0400
Date: Wed, 6 Aug 2014 14:42:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Evgeny Budilovsky <budevg@gmail.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>, Peng Tao <bergwolf@gmail.com>,
        Lai Siyao <lai.siyao@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu
 protected current->real_parent field
Message-ID: <20140806214216.GA16530@kroah.com>
References: <87k36ltoob.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k36ltoob.fsf@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 09:22:43PM +0300, Evgeny Budilovsky wrote:
> 
> 
> Signed-off-by: Evgeny Budilovsky <budevg@gmail.com>

Why is this needed?  Is the current code a bug?  Where was the reference
added?  Is this causing a problem without this patch applied?  How far
back should it be backported, if at all?

I need lots more details here before I can take this patch, sorry.

greg k-h
