Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaHGTsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:48:55 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33808 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaHGTsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <CABdoFFd9ZuikFyaSfOyn-babECtno50_GGNHofK1-LmhLCqeTw@mail.gmail.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
	<20140807053344.GA5754@kroah.com>
	<CABdoFFd9ZuikFyaSfOyn-babECtno50_GGNHofK1-LmhLCqeTw@mail.gmail.com>
Date: Thu, 7 Aug 2014 13:48:53 -0600
Message-ID: <CAKocOONNKZXHS1+ZDrMRu4noOCi+OmSVvhcxBrH+iNDyB1B7zw@mail.gmail.com>
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
From: Shuah Khan <shuahkhan@gmail.com>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, Federico Manzan <f.manzan@gmail.com>,
        Kurt Garloff <kurt@garloff.de>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        Andy Grover <andy.grover@gmail.com>, max@vozeler.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 1:36 PM, Valentina Manea
<valentina.manea.m@gmail.com> wrote:
> On Wed, Aug 6, 2014 at 10:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Thu, Aug 07, 2014 at 08:10:25AM +0300, Valentina Manea wrote:
>>> This is a resend of the patch series from March.
>>>
>>> After migrating userspace code to libudev, converting usbip-host
>>> to a device driver and various bug fixes and enhancements, USB/IP
>>> is fully functional and can be moved out of staging.
>>>
>>> This patch series moves it as following:
>>> * userspace code to tools/usb/usbip
>>> * kernel code to drivers/usb/usbip
>>>
>>> Besides this, a warning generated in the kernel code is solved.
>>
>> What kernel version is this against?
>>
>
> I rebased my tree against master in the staging tree.
>
>> And can we get a maintainer for this code?  I don't want to see it sit
>> "ownerless" in the kernel tree.  Will you be willing to do this?
>>
>
> Yes. But I should be briefed about that responsibilities will this involve.
>

If you would like a back-up, I can volunteer to be co-maintainer for this
driver.

-- Shuah
