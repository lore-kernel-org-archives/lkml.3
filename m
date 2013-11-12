Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3KLJOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:14:22 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:59764 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3KLJOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:14:17 -0500
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
In-Reply-To: <528178B8.4000704@fnarfbargle.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
	<CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
	<528178B8.4000704@fnarfbargle.com>
Date: Tue, 12 Nov 2013 04:14:15 -0500
Message-ID: <CAO9zADwwhw9qQ7GMh45-4AXktp8UmsVOLDVVwSfc5gQS1QTENQ@mail.gmail.com>
Subject: Re: 3.12: raid-1 mismatch_cnt question
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 7:39 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> On 11/07/2013 06:54 PM, Justin Piszcz wrote:
>>
>> On Mon, Nov 4, 2013 at 5:25 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> I run two SSDs in a RAID-1 configuration and I have a swap partition on a
>>> third SSD.  Over time, the mismatch_cnt between the two devices grows
>>> higher
>>> and higher.
>>>
>
> Are both SSD's identical? Do you have discard enabled on the filesystem?
Yes (2 x Intel SSDSC2CW240A3) & yes )/dev/root on / type ext4
(rw,relatime,discard,data=ordered))

>
> The reason I ask is I have a RAID10 comprised of 3 Intel and 3 Samsung
> SSD's. The Intel return 0 after TRIM while the Samsung don't, so I _always_
> have a massive mismatch_cnt after I run fstrim. I never use a repair
> operation as it's just going to re-write the already trimmed sectors.
Very interesting and good to know!

Justin.
