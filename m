Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaEFSsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:48:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:53123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbaEFSsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="428424774"
Date: Tue, 6 May 2014 11:48:40 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, David Miller <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506184840.GN19657@tassilo.jf.intel.com>
References: <20140506155703.GA20391@cloud>
 <20140506.115941.428706504757835279.davem@davemloft.net>
 <20140506164108.GA20536@cloud>
 <20140506.131643.994244006906866938.davem@davemloft.net>
 <20140506175547.GE20776@cloud>
 <CAM_iQpUgj7BqpzRL070DEGQ32SWwN68BRgM5DtFqvBLjGGOLQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUgj7BqpzRL070DEGQ32SWwN68BRgM5DtFqvBLjGGOLQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So why bothers 3.15+ Linux kernel? Why not use an old kernel e.g. 2.4.x?
> 2.4.x kernel doesn't have so many new features you want to get rid of here.

Nobody wants to be stuck on an ancient kernel forever.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
