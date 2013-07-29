Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3G2FVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:21:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:5567 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab3G2FVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,766,1367996400"; 
   d="scan'208";a="338270207"
Date: Mon, 29 Jul 2013 13:05:14 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>, Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130729170514.GB30371@linux-youquan.bj.intel.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com> <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com> <20130724062254.GA16400@redhat.com> <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. It would be great, if Youquan can point out where is the intel doc
> about the change.
> 
> Also if the patch can move on,  hypervisor_x2apic_available() related
> declaration and define
> could be dropped.

Hi Yinghai,

Sorry I do not know the document change but I also do not find the
words/description/explanation that x2APIC physical mode also need interrupt
 remapping support when CPU < 256. Of course, X2APIC cluster mode must
has interrupt remapping support. 

I have tested many machines, both old and most recent machines and from
desktop to server, x2APIC physical mode works without interrupt
remapping when CPU < 256.

In theory and real test, I do not find any issue about the patch.

In order to make sure the patch without involving unexpected issues beyond
I can understand, I will confirm with our expert about it.

so please pend the patch going to mainline. If the patch can move on, I
think I will also provide other patch changing, like direct EOI.

Thanks
-Youquan
 
