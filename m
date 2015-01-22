Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbbAVIBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:01:04 -0500
Received: from mailrelay6.public.one.com ([91.198.169.200]:55777 "EHLO
	mailrelay6.public.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbAVIAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:00:55 -0500
X-HalOne-Cookie: 80efae67f694411ec2d71bdb7374534ad7440a3f
X-HalOne-ID: c8010517-a20c-11e4-9705-b82a72d06996
Message-ID: <54C0AE3A.6040905@bitmath.org>
Date: Thu, 22 Jan 2015 09:00:58 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fixing touch point jumps in the kernel (was Re: [PATCH] MAINTAINERS:
 Update rydberg's addresses)
References: <1418979967-2134-1-git-send-email-rydberg@bitmath.org> <CAN+gG=Gmgk+wKSnHkSAERoWt+1PqAojNSZt6jo=qmzPOqJs+3Q@mail.gmail.com> <54BED60C.3030303@bitmath.org> <20150121043520.GB17900@jelly.redhat.com> <54BFC4D3.6090607@bitmath.org> <CAN+gG=EUNk8AR4PR3qk8L05stx1jUEn9anA6xi+1Qjob00h_hg@mail.gmail.com> <54C00046.1000305@bitmath.org> <20150122042123.GC23132@jelly.redhat.com>
In-Reply-To: <20150122042123.GC23132@jelly.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> from the testing I've done, you cannot trigger this except by lifting a
> finger and raising a finger. There is no per-use-case requirement, it's a
> hardware deficiency that the hardware simply cannot detect this specific
> case of finger change.

This is a good selling point, but...

> again, you cannot trigger this by moving. or at least if you do your
> pointer would be in the bottom right corner anyway because you have to move
> the finger so insanely fast that pointer control is clearly not in the
> picture anymore.

this is what puts me off again. It takes me back to the old arcade days, and
watching kids hammer at the controls. What is insane for one person may not be
insane for another.

That said, I understand and agree that there exists an upper move velocity that
makes sense for any particular touchpad.

So I will accept two patches on this: one to set the speed limit in the MT
layer, and one which uses that limit to solve a real problem, for the touchpad
in question.

Let's end this thread here and leave unrelated people in peace.

Thanks,
Henrik

