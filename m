Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbbAUPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:25:57 -0500
Received: from mailrelay7.public.one.com ([91.198.169.215]:13138 "EHLO
	mailrelay7.public.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbbAUPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:25:06 -0500
X-HalOne-Cookie: de7c209597658a54ad4e0e6482373d498968be9f
X-HalOne-ID: ab3002fe-a181-11e4-bf9a-b82a72cffc46
Message-ID: <54BFC4D3.6090607@bitmath.org>
Date: Wed, 21 Jan 2015 16:25:07 +0100
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
Subject: Re: [PATCH] MAINTAINERS: Update rydberg's addresses
References: <1418979967-2134-1-git-send-email-rydberg@bitmath.org> <CAN+gG=Gmgk+wKSnHkSAERoWt+1PqAojNSZt6jo=qmzPOqJs+3Q@mail.gmail.com> <54BED60C.3030303@bitmath.org> <20150121043520.GB17900@jelly.redhat.com>
In-Reply-To: <20150121043520.GB17900@jelly.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> it wasn't the first reaction. it was the third, after we hacked up
> synaptics [1], then libinput [2], both rather unsatisfactory. Not sure what
> chromeos does but they'll probably would need similar code. And any other
> users of the evdev API of course.

So if this approach did not work very well in userland, why would it work any
better in the kernel?

Henrik

