Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3BTWvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:51:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59772 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3BTWvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:51:43 -0500
Message-ID: <51255329.4070506@zytor.com>
Date: Wed, 20 Feb 2013 14:50:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, ciminaghi@gnudd.com, alan@linux.intel.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH V5 4/5] drivers/amba: add support for a PCI bridge
References: <51254F57.7060603@zytor.com>  <cover.1361393832.git.rubini@gnudd.com> <52b9f4e1cc04b7c656e10ee16020090601f6f537.1361393832.git.rubini@gnudd.com> <20130220222419.GX17833@n2100.arm.linux.org.uk> <20130220224528.GA24819@mail.gnudd.com>
In-Reply-To: <20130220224528.GA24819@mail.gnudd.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 02:45 PM, Alessandro Rubini wrote:
> [meanwhile I posted V6 with the acked-by of linusw and others, that
> were missing in V5]
> 
> rmk:
>>> I'm happy to take it through my tree if everyone is now happy with this.
> 
> hpa: 
>> I am okay with that, although I would like to make sure we do a bunch of
>> x86 randconfigs on it before pushing it to Linus.
> 
> I did like this:
>   - disable STA2X11 (and thus AMBA) and build
>   - enable STA2X11, answer y to all new questions and build
> 
> So there's nothing left (you'll have two unrelated warnings, that I'm
> working on and I'll post a fix tomorrow).  Sure, Peter, first time I
> didn't do that test and missed some of the drivers.
> 

I was just concerned that rmk wouldn't necessarily do those tests as a
matter of process.

So Russell -- how do you want to handle this?  Should I take them (and
ask Ingo to put them through his test machinery) or do you want to (and
run x86 randconfigs as part of your testing)?

	-hpa


