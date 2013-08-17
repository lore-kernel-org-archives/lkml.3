Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3HQJD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 05:03:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43016 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752299Ab3HQJDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 05:03:55 -0400
Message-ID: <1376730231.1954.7.camel@joe-AO722>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 17 Aug 2013 02:03:51 -0700
In-Reply-To: <20130817082419.GA10005@pd.tnic>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com>
	 <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
	 <20130724062254.GA16400@redhat.com>
	 <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
	 <20130729170514.GB30371@linux-youquan.bj.intel.com>
	 <20130814184040.GA6726@linux-youquan.bj.intel.com>
	 <20130814111105.GA13772@gmail.com>
	 <20130817134454.GA16835@linux-youquan.bj.intel.com>
	 <20130817074256.GA18772@gmail.com> <20130817082419.GA10005@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-17 at 10:24 +0200, Borislav Petkov wrote:
> On Sat, Aug 17, 2013 at 09:42:56AM +0200, Ingo Molnar wrote:
> > 
> > * Youquan Song <youquan.song@linux.intel.com> wrote:
[]
> > Firstly, please use the customary (multi-line) comment 
> > style:
> > 
> >   /*
> >    * Comment .....
> >    * ...... goes here.
> >    */
> > 
> > specified in Documentation/CodingStyle.
> 
> This keeps popping up. Maybe it should be in checkpatch, Joe?
> With the special handling of net/ and drivers/net/ of course.

I don't feel that's useful.
You're welcome to add it if you want to.

checkpatch tends to be used for firs patch submissions and
adding it would only encourage a new wave of trivial whitespace
patches.

I think there are already way, _way_ too many existing instances
of comments that are of the form
	/* foo
	 * ...
to add that.

There are 10s of thousands outside of net/ and drivers/net/.


