Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3KGKyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:54:07 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55197 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3KGKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:54:04 -0500
MIME-Version: 1.0
X-Originating-IP: [72.21.198.64]
In-Reply-To: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
Date: Thu, 7 Nov 2013 05:54:01 -0500
Message-ID: <CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
Subject: Re: 3.12: raid-1 mismatch_cnt question
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: open list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 4, 2013 at 5:25 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> I run two SSDs in a RAID-1 configuration and I have a swap partition on a
> third SSD.  Over time, the mismatch_cnt between the two devices grows higher
> and higher.
>
> Once a week, I run a check and repair against the md devices to help bring
> the mismatch_cnt down.  When I run the check and repair, the system is live
> so there are various logs/processes writing to disk.  The system also has
> ECC memory and there are no errors reported.
>
> The following graph is the mismatch_cnt from June 2013 to current; each drop
> represents a check+repair.  In September, I dropped the kernel/vm caches
> before running check/repair and that seemed to help a bit.
> http://home.comcast.net/~jpiszcz/20131104/md_raid_mismatch_cnt.png
>
> My question is: is this normal or should the mismatch_cnt always be 0 unless
> there is a HW or md/driver issue?
>
> Justin.
>

Hi,

Could anyone please comment if this is normal/expected behavior?

Thanks,

Justin.
