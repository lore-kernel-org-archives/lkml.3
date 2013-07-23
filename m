Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab3GWSkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:40:23 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:34957 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933744Ab3GWSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805BA08A@ORSMSX109.amr.corp.intel.com>
References: <20130722013758.GA14337@google.com>
	<1828884A29C6694DAF28B7E6B8A82373805BA08A@ORSMSX109.amr.corp.intel.com>
Date: Tue, 23 Jul 2013 21:40:17 +0300
Message-ID: <CAJZOPZ+AUacLM_3u4tRMdRWOiW1=CgObwRe_3KnQCTmMgVtZRA@mail.gmail.com>
Subject: Re: infiniband build warning
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Michel Lespinasse <walken@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-rdma (linux-rdma@vger.kernel.org)" 
	<linux-rdma@vger.kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 8:40 AM, Hefty, Sean <sean.hefty@intel.com> wrote:
>> I am seeing build warnings in drivers/infiniband/core/cma.c starting with
>> v3.11-rc1. These can be reproduced with gcc 4.6.3.
>> Would you consider applying the following fix ?

> A patch to fix this was submitted to the linux-rdma list last week.

Hi Roland,

There is a nice set of patches (IPoIB virtualization fixes, mlx5
fixes, iser patches to cope with Connect-IB no FMR, etc, etc) posted
to linux-rdma little before && after 3.11-rc1 was out, and we are @
rc2 now. I think we need to get them upstreamed around this time such
that its early enough in the cycle, makes sense?

Or.
