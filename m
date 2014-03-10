Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaCJNgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:36:23 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35919 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaCJNgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140221153905.GE31902@saruman.home>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
	<20140220182257.GF23217@saruman.home>
	<a39ce44a-2f92-4067-be6d-7311a78bb195@VA3EHSMHS013.ehs.local>
	<20140221153905.GE31902@saruman.home>
Date: Mon, 10 Mar 2014 19:06:19 +0530
Message-ID: <CALHRZuouwUh398PkmatQMyZNzrEreH-kGwJTTC7CsY_gdq8dbQ@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: balbi@ti.com
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 9:09 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Feb 21, 2014 at 11:27:07AM +0000, Subbaraya Sundeep Bhatta wrote:
>> > From the looks of it, I doubt this was actually tested, you need a lot
>> > of work on this driver.
>> Tested on both ARM and Microblaze architectures with Mass storage gadget.
>> Will send a v2 after addressing all your comments.
>
> clearly you didn't try to remove and reinsert the module or you would
> see a whole bunch of errors.
>

Yes you are correct. My console hung up as soon as i rmmod my driver.
Could you please point me where am wrong.

>> This email and any attachments are intended for the sole use of the
>> named recipient(s) and contain(s) confidential information that may be
>> proprietary, privileged or copyrighted under applicable law. If you
>> are not the intended recipient, do not read, copy, or forward this
>> email message or any attachments. Delete this email message and any
>> attachments immediately.
>
> remove this footer message, btw, when sending emails to public mailing
> lists.
>
Sure
> --
> balbi
