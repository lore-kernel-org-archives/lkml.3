Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBUUJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:09:24 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36542 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBUUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:09:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA72=8KvdOgTLc7NZfMq_bFob6-rEhTktNJJ0qBRgr4iiQ@mail.gmail.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
	<1392986945-9693-86-git-send-email-luis.henriques@canonical.com>
	<CAA_Uwz+DZJ0f6ow3YSsSK9HDt639P7Up4_5ienoJO5VW4ZhF2Q@mail.gmail.com>
	<CA+5PVA72=8KvdOgTLc7NZfMq_bFob6-rEhTktNJJ0qBRgr4iiQ@mail.gmail.com>
Date: Fri, 21 Feb 2014 21:09:22 +0100
Message-ID: <CANq1E4Q4h5rF1MY+hp5DS9M7Jo43Op_gRZgBJtiTHswX0EAEDA@mail.gmail.com>
Subject: Re: [PATCH 3.11 085/121] tty: Set correct tty name in 'active' sysfs attribute
From: David Herrmann <dh.herrmann@gmail.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ray Strode <halfline@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>, Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Feb 21, 2014 at 3:46 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Fri, Feb 21, 2014 at 9:37 AM, Ray Strode <halfline@gmail.com> wrote:
>> Hi,
>>
>> This broke plymouth, i think.  Plymouth used the herustic:
>> "/sys/class/tty/console/active contains something other than tty0" to
>> mean "probably has serial consoles, force verbose messages instead of
>> a splash screen".  Now on a normal system it contains tty1.
>>
>> I pushed a commit to plymouth that gets it working again, but it could
>> cause compatiblity concerns if new kernels are pushed to old releases.
>
> Hm.  Breaking userspace is probably a bad thing here.
>
> Greg, you have this queued for 3.13.5 at the moment.  Maybe we should
> hold off on this one until this discussion is sorted out?

Looks like a broken patch, not a broken idea. So you should probably
hold off on this one till we figure it out. See Kay's comment on
Greg's series for more.

Thanks
David
