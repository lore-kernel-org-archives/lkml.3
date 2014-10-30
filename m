Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaJ3EjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:39:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaJ3EjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:39:20 -0400
Date: Wed, 29 Oct 2014 21:39:18 -0700
From: Darren Hart <dvhart@infradead.org>
To: kernel test robot <fengguang.wu@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [LKP] [futex] 76835b0ebf8: -12.1% will-it-scale.per_process_ops
Message-ID: <20141030043918.GK14609@vmdeb7>
References: <20141027021822.GH27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027021822.GH27038@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:18:22AM +0800, kernel test robot wrote:
> FYI, we noticed the below changes on
> 
> commit 76835b0ebf8a7fe85beb03c75121419a7dec52f0 ("futex: Ensure get_futex_key_refs() always implies a barrier")

Wow, this is great information to get for free. Thanks Fengguang!

-- 
Darren Hart
Intel Open Source Technology Center
