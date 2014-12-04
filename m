Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaLDUpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:45:39 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59788 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaLDUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:45:38 -0500
Date: Thu, 4 Dec 2014 15:45:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Leonard Crestez <lcrestez@ixiacom.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
Message-ID: <20141204204534.GE4080@htj.dyndns.org>
References: <547E3E57.3040908@ixiacom.com>
 <20141204175713.GE2995@htj.dyndns.org>
 <5480BFAA.2020106@ixiacom.com>
 <alpine.DEB.2.11.1412041426230.14577@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412041426230.14577@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Thu, Dec 04, 2014 at 02:28:10PM -0600, Christoph Lameter wrote:
> Well this is not a common use case and that is not what the per cpu
> allocator was designed for. There is bound to be signifcant fragmentation
> with the current design. The design was for rare allocations when
> structures are initialized.

My unverified gut feeling is that fragmentation prolly is a lot less
of a problem for percpu allocator given that most percpu allocations
are fairly small.  On the other hand, we do wanna pack them tight as
percpu memory is really expensive space-wise.  I could be wrong tho.

Thanks.

-- 
tejun
