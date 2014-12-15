Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaLOLcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:32:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaLOLcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:32:32 -0500
Message-ID: <548EC6C3.9060902@redhat.com>
Date: Mon, 15 Dec 2014 12:32:19 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB driver patches for 3.19-rc1
References: <20141214223523.GA3802@kroah.com> <CA+55aFx4V9urJ=_Ai0-zuQmQvzpz-t250bgDZBEDhWUbfe3oBQ@mail.gmail.com>
In-Reply-To: <CA+55aFx4V9urJ=_Ai0-zuQmQvzpz-t250bgDZBEDhWUbfe3oBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 15-12-14 00:06, Linus Torvalds wrote:
> On Sun, Dec 14, 2014 at 2:35 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> Hans de Goede (1):
>>        uas: Make uas work with blk-mq
>
> So I got some fairly trivial conflicts on this one (conflicting with
> the scsi cleanups mainly by Christoph Hellwig.
>
> I resolved the conflict easily, and it all *looks* fine, but quite
> frankly, I'd be a lot happier about it if somebody who has the
> hardware were to actually test the end result.   The whole interaction
> with ".use_blk_tags" etc should be verified by somebody who knows the
> code.

Code wise this looks good and I've just given:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

a spin with an uas disk enclosure, and verified that tcq is being used,
and everything works fine.

Regards,

Hans
