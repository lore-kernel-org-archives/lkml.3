Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaF3JRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:17:36 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52724 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaF3JRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140619211403.GA3589@kroah.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com> <20140619211403.GA3589@kroah.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Mon, 30 Jun 2014 11:17:13 +0200
Message-ID: <CAMxnaaWhFZov1wNpWUcPzKwMAvBArinrfdGg+UOGJokkLqFsZA@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] Thunderbolt driver for Apple MacBooks
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 11:14 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jun 03, 2014 at 10:03:57PM +0200, Andreas Noever wrote:
>> Hi,
>>
>> Updated version of the driver. Includes changes by Matthew to make it work on
>> Falcon Ridge hardware (present in the newest Mac(Book)Pro).
>>
>> Changes since v4 (suggested by Matthew):
>>  - Changed the PCI quirks to check just for Apple hardware instead of checking
>>    against a list of machines. (The PCI id check already restricts this quirk
>> to the relevant Apple machines).
>>  - Added Falcon Ridge PCI id to the driver and to the "wait_for_thunderbolt"
>>    quirk (the "poweroff_thunderbolt" quirk is no longer necessary for Falcon
>> Ridge devices).
>>  - Fixed plug events for Falcon Ridge hardware.
>
> Very nice work, I've now queued this up for 3.17 merge.
>
>> @Matthew: I think that your patch was missing the Falcon Ridge PCI id within
>> the wait_for_thunderbolt quirk (I have added it). If you have time could you
>> verify that suspend/resume works on your MacPro?  Thanks!
>>
>> As before Matthew's ACPI changes (latest version: [1]) are required for this to
>> work properly. Without them you need to boot with a coldplugged TB device to
>> prevent the firmware from disabling the controller.
>
> What is the status of these patches making it in for 3.17?
>
Hi Matthew,

any news on these ACPI patches?

thanks,
Andreas
