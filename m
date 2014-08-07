Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaHGTgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:36:09 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:49203 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaHGTgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140807053344.GA5754@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
	<20140807053344.GA5754@kroah.com>
Date: Thu, 7 Aug 2014 12:36:06 -0700
Message-ID: <CABdoFFd9ZuikFyaSfOyn-babECtno50_GGNHofK1-LmhLCqeTw@mail.gmail.com>
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, Federico Manzan <f.manzan@gmail.com>,
        Kurt Garloff <kurt@garloff.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        Andy Grover <andy.grover@gmail.com>, max@vozeler.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 10:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Aug 07, 2014 at 08:10:25AM +0300, Valentina Manea wrote:
>> This is a resend of the patch series from March.
>>
>> After migrating userspace code to libudev, converting usbip-host
>> to a device driver and various bug fixes and enhancements, USB/IP
>> is fully functional and can be moved out of staging.
>>
>> This patch series moves it as following:
>> * userspace code to tools/usb/usbip
>> * kernel code to drivers/usb/usbip
>>
>> Besides this, a warning generated in the kernel code is solved.
>
> What kernel version is this against?
>

I rebased my tree against master in the staging tree.

> And can we get a maintainer for this code?  I don't want to see it sit
> "ownerless" in the kernel tree.  Will you be willing to do this?
>

Yes. But I should be briefed about that responsibilities will this involve.

Thanks,
Valentina
