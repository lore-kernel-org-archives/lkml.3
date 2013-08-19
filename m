Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab3HSHLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:11:33 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60372 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3HSHLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:11:32 -0400
Date: Mon, 19 Aug 2013 09:11:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130819071128.GA26184@gmail.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com>
 <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
 <20130724062254.GA16400@redhat.com>
 <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
 <20130729170514.GB30371@linux-youquan.bj.intel.com>
 <20130814184040.GA6726@linux-youquan.bj.intel.com>
 <20130814111105.GA13772@gmail.com>
 <20130817134454.GA16835@linux-youquan.bj.intel.com>
 <20130817074256.GA18772@gmail.com>
 <20130817195232.GA22050@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130817195232.GA22050@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Youquan Song <youquan.song@linux.intel.com> wrote:

> > Firstly, please use the customary (multi-line) comment 
> > style:
> > 
> >   /*
> >    * Comment .....
> >    * ...... goes here.
> >    */
> > 
> > specified in Documentation/CodingStyle.
> > 
> > Secondly, please send a patch against a vanilla (e.g. 
> > v3.11-rc5) kernel, as I've already zapped your previous 
> > patch from tip:x86/apic per your request.
> Hi Ingo,
> 
> latest vanilla has no includes the patch yet, so I think it
>  will be fine by only dropping it from tip tree.

I know that it's not included yet - because I have not sent 
it to Linus.

My suggestion was to document the circumstances here via a 
single patch, i.e. not a patch + revert-and-add-comments 
patch, but via a simple add-comments patch. Agreed?

Thanks,

	Ingo
