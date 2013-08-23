Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3HWQxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:53:09 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47725 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab3HWQxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6Ky1FQeRjjbhja2KC7EYGJ2nR1ZNuYjYi89DoqLse2cw@mail.gmail.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
 <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com>
 <CAErSpo5AiRw7HvGQMq-n596ZkHJs_KJNn346yf+jc7yti-xpUw@mail.gmail.com>
 <CAErSpo4E9LNrfqTq1_WUoAx68_krw23BjSYbPpJPOr=zbq98xA@mail.gmail.com> <CAErSpo6Ky1FQeRjjbhja2KC7EYGJ2nR1ZNuYjYi89DoqLse2cw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 23 Aug 2013 10:52:45 -0600
Message-ID: <CAErSpo7m=YB=1cHSBTwufTHAiAd+k9Re2s-ro509BELOgK8j7Q@mail.gmail.com>
Subject: Re: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00
 to PF Nacked" messages
To: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 5:37 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Aug 20, 2013 at 5:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Aug 13, 2013 at 8:23 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>>> I played with this a little more and found this:
>>>
>>> 1) Magma card in z420, connected to chassis containing X540: fails
>>> (original report)
>>> 2) X540 in z420, Magma card in z420, connected to empty chassis: fails
>>> 3) X540 in z420, Magma card in z420 but no cable to chassis: works
>
> For what it's worth, I tried config 3 again with v3.11-rc6, and it
> failed the same way.  I haven't bothered with config 2.  It's not 100%
> reproducible, but at least it doesn't seem related to the expansion
> chassis.
>
> I attached the logs from config 3 to
> https://bugzilla.kernel.org/show_bug.cgi?id=60776

Is there anything I can do to help debug this?  Add instrumentation,
etc.?  It seems like I'm doing the simplest possible thing -- just
writing to the sysfs sriov_num_vfs file to enable VFs.

I almost think it must be related to my config somehow if nobody else
is seeing this, but at the same time, my config also seems the
simplest possible, so I don't know what I could be doing that's
unusual.

Bjorn
