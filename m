Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3IWRRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab3IWRRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:17:01 -0400
Date: Mon, 23 Sep 2013 13:15:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, matthew.garrett@nebula.com,
        Greg KH <greg@kroah.com>, d.kasatkin@samsung.com,
        kexec@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 00/16] [RFC PATCH] Signed kexec support
Message-ID: <20130923171515.GD10812@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <20130912034023.GA10877@kroah.com>
 <20130912114336.GA28500@redhat.com>
 <20130912161705.GA2650@kroah.com>
 <1379010250.9796.118.camel@dhcp-9-2-203-236.watson.ibm.com>
 <20130916142852.GB20753@redhat.com>
 <CAAQYJAuXy2up+XTE1AAgOg2u7t=LqOFyPv96RP+1avLC45UDJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAQYJAuXy2up+XTE1AAgOg2u7t=LqOFyPv96RP+1avLC45UDJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:51:21PM +0200, Andrea Adami wrote:
> Hello,
> 
> as one of the developers of kexecboot, a kexec-based
> linux-as-bootloader, I'm following with interest this thread.
> FWIW since the beginning we are compiling kexec-tools statically
> against klibc for size constraints.

Hi Andrea,

Good to know about kexecboot.

FWIW, recently we discussed the kexec/kdump with secureboot issue
at Linux Plumbers and Greg KH suggested that it will be simpler if
we implement a new system call which does the job of loading new
kernel. Effectively that means reimplementing /sbin/kexec in kernel.
This will also mean maintaining two code bases for some time and
slowly deprecating one over a period of time.

I will probably start with something  small and post proof of concept
patches for review and see how does that go. This is just heads up 
on what I am planning to do.

Thanks
Vivek
