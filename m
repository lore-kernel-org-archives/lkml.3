Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab3CAElJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:41:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3CAElH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:41:07 -0500
Date: Thu, 28 Feb 2013 20:40:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
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
Message-Id: <20130228204046.e54f2d28.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
	<512D7FAD.1040003@jp.fujitsu.com>
	<CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
	<512D8EDA.3010602@jp.fujitsu.com>
	<CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
	<512DBD24.7090302@cn.fujitsu.com>
	<20130227132612.14664a3a.akpm@linux-foundation.org>
	<CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com>
	<51302481.9070005@cn.fujitsu.com>
	<CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013 20:32:15 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Yingai, Andrew,
>  is this ok with you two?

If it works.  I haven't tested it yet!  Ordinarily I'd give it a few
days for -next testing and to let Fengguang's testbot chew on it. 
