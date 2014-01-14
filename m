Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaANXYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:24:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:2818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaANXYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:24:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="458852786"
Message-ID: <52D5C6F2.7090607@linux.intel.com>
Date: Tue, 14 Jan 2014 15:23:30 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
References: <20140114133125.GB26942@localhost> <CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>
In-Reply-To: <CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 02:33 PM, Kees Cook wrote:
> 
> Can you tell me how the initrd for quantal-core-x86_64.cgz was built
> in the qemu instances you're using? It seems like all the failures
> point to a problem with how kASLR is interacting with the initrd.
> 

If kASLR somehow causes the kernel to collide with the initrd that would
be problem...
	
	-hpa


