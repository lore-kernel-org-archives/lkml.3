Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaKGVje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:39:34 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:41545 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaKGVjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141107193054.GB29311@kroah.com>
References: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
	<1415038066-22423-2-git-send-email-mathieu.poirier@linaro.org>
	<20141107193016.GA29311@kroah.com>
	<20141107193054.GB29311@kroah.com>
Date: Fri, 7 Nov 2014 14:39:31 -0700
Message-ID: <CANLsYkzKB7iBUFxsqmaoHob26mEZvfbVSA1O_ZadFCYHE2viAA@mail.gmail.com>
Subject: Re: [PATCH v9 01/12] coresight: add CoreSight core layer framework
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>, Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        trollkarlen Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 12:30, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 07, 2014 at 11:30:16AM -0800, Greg KH wrote:
>> On Mon, Nov 03, 2014 at 11:07:35AM -0700, mathieu.poirier@linaro.org wrote:
>> > From: Pratik Patel <pratikp@codeaurora.org>
>> >
>> > CoreSight components are compliant with the ARM CoreSight
>> > architecture specification and can be connected in various
>> > topologies to suit a particular SoC tracing needs. These trace
>> > components can generally be classified as sources, links and
>> > sinks. Trace data produced by one or more sources flows through
>> > the intermediate links connecting the source to the currently
>> > selected sink.
>> >
>> > The CoreSight framework provides an interface for the CoreSight trace
>> > drivers to register themselves with. It's intended to build up a
>> > topological view of the CoreSight components and configure the
>> > correct serie of components on user input via sysfs.
>> >
>> > For eg., when enabling a source, the framework builds up a path
>> > consisting of all the components connecting the source to the
>> > currently selected sink(s) and enables all of them.
>> >
>> > The framework also supports switching between available sinks
>> > and provides status information to user space applications
>> > through the debugfs interface.
>> >
>> > Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> You don't seem to document the sysfs files you create here in
>> Documentation/ABI/ anywhere in the series.  Can you fix that up?

Thanks for the review.   Do you want sysfs entries documented for the
framework only or all the ones created by the drivers as well?

>>
>> Other than that minor nit, this looks good to me.  Feel free to take it
>> through some random ARM tree.
>
> Wait, did you want me to take this through my tree?  If so, I'll be glad
> to do so, I can't remember what we talked about here...

I was hoping to go through yours.

>
> thanks,
>
> greg k-h
