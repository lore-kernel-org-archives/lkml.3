Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3CKUwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:52:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46045 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3CKUwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:52:40 -0400
Message-ID: <513E438D.5010303@zytor.com>
Date: Mon, 11 Mar 2013 13:50:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com> <513E28B8.3000502@zytor.com> <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com> <20130311192021.GF12107@redhat.com> <513E36CB.5040908@zytor.com> <20130311201245.GC14738@redhat.com> <513E3C44.9030402@zytor.com> <87hakhk6xu.fsf@xmission.com> <20130311204530.GE14738@redhat.com>
In-Reply-To: <20130311204530.GE14738@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 01:45 PM, Vivek Goyal wrote:
> 
> - Now we use dracut generated initramfs and it has been growing in size.
>   Now systemd has been pulled in too.
> 

And the solution to that isn't obvious?

> - makdumpfile needs more memory to dump large machines.
> 
> There are so many places where memory usage is going up and trying
> to keep track of all that has been very hard.

Seriously, in particular the O(n) memory requirements you may want to
think very very hard about.

	-hpa


