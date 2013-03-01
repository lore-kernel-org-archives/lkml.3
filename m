Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3CAPqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:46:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54202 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3CAPqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:46:00 -0500
Message-ID: <5130CC92.1080003@zytor.com>
Date: Fri, 01 Mar 2013 07:43:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Lin Feng <linfeng@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        Gui jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com> <512DBD24.7090302@cn.fujitsu.com> <20130227132612.14664a3a.akpm@linux-foundation.org> <CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com> <51302481.9070005@cn.fujitsu.com> <CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com> <513030AF.70208@zytor.com> <CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com> <5130447F.4070706@jp.fujitsu.com> <CAE9FiQWLys4BopOzSfVK8Smt6xzN+Q=xNk801nS6ac2qZEgo3w@mail.gmail.com>
In-Reply-To: <CAE9FiQWLys4BopOzSfVK8Smt6xzN+Q=xNk801nS6ac2qZEgo3w@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 11:55 PM, Yinghai Lu wrote:
> 
> Let me try again:
> 
> movablemem_map is broken idea or poor design.
> 

Very much so.  I have said this before: this is potentially useful
during development/testing, but anyone who expects to actually tell
their customers to use it is abusive.

	-hpa

