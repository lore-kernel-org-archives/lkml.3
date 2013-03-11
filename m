Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3CKUo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:44:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45953 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab3CKUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:44:56 -0400
Message-ID: <513E41BD.3030003@zytor.com>
Date: Mon, 11 Mar 2013 13:42:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com> <513E28B8.3000502@zytor.com> <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com> <20130311192021.GF12107@redhat.com> <513E36CB.5040908@zytor.com> <20130311201245.GC14738@redhat.com> <513E3C44.9030402@zytor.com> <87hakhk6xu.fsf@xmission.com>
In-Reply-To: <87hakhk6xu.fsf@xmission.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 01:38 PM, Eric W. Biederman wrote:
> 
> I totally makes sense to figure out how to load a kernel high.  I am not
> convinced kexec on panic is the best use of that ability.  I would argue
> that it might be better to figure out how to use a small memory
> foot-print and try to keep that foot-print from growing.
> 

I could not agree more with this.  The whole reason this is a problem is
because we are talking about hundreds of megabytes of crashkernel.  If
we can fix *that* problem, we are much better off.

	-hpa


