Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3HQII2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 04:08:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:18313 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3HQIIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 04:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,900,1367996400"; 
   d="scan'208";a="347636609"
Date: Sat, 17 Aug 2013 15:52:32 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130817195232.GA22050@linux-youquan.bj.intel.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com> <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com> <20130724062254.GA16400@redhat.com> <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com> <20130729170514.GB30371@linux-youquan.bj.intel.com> <20130814184040.GA6726@linux-youquan.bj.intel.com> <20130814111105.GA13772@gmail.com> <20130817134454.GA16835@linux-youquan.bj.intel.com> <20130817074256.GA18772@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130817074256.GA18772@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Firstly, please use the customary (multi-line) comment 
> style:
> 
>   /*
>    * Comment .....
>    * ...... goes here.
>    */
> 
> specified in Documentation/CodingStyle.
> 
> Secondly, please send a patch against a vanilla (e.g. 
> v3.11-rc5) kernel, as I've already zapped your previous 
> patch from tip:x86/apic per your request.
Hi Ingo,

latest vanilla has no includes the patch yet, so I think it
 will be fine by only dropping it from tip tree.

Thanks
-Youquan
 
