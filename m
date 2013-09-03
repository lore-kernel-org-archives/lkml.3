Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab3ICMdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:33:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41893 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932710Ab3ICMdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:33:23 -0400
Date: Tue, 3 Sep 2013 13:33:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 0/8] partitions/efi: detect hybrid mbrs
Message-ID: <20130903123317.GH28598@console-pimps.org>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
 <20130806141603.948961cecfc9426aeee7c083@linux-foundation.org>
 <1376585982.2152.2.camel@buesod1.americas.hpqcorp.net>
 <20130815122949.aff0bc4821e4adaec8eb359b@linux-foundation.org>
 <1376617039.2389.2.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376617039.2389.2.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug, at 06:37:19PM, Davidlohr Bueso wrote:
> Cc'ing Matt Fleming.
> 
> Karel, I believe you took a look at these, any thoughts?

While I haven't tested these patches, because none of my systems use
this MBR scheme, they seem fairly straight forward.

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
