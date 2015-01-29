Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbbA2HxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:53:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbbA2HxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:53:00 -0500
Message-ID: <54C9E6D6.6090305@redhat.com>
Date: Thu, 29 Jan 2015 08:52:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] New Lenovos 2015 touchpads: party time!
References: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin & et al,

On 28-01-15 21:10, Benjamin Tissoires wrote:
> Hi Dmitry,
>
> Lenovo released their new models, and believe it or not, some kernel
> work is required to support them!
>
> We learned the lesson and we will try to maximize the effort in user space
> through udev rules instead of polluting the kernel with exceptions.
>
> Patches 1 & 2 are general fixes for synaptics that have been unnoticed
> until this new models. They are marked as stable.
>
> Patch 3 is a generic way to fix the PnpId list that was hardcoded in the
> kernel. This one is also marked as stable so that distributions will not
> have the top software buttons on devices that do not require it.
>
> Patch 4 is a nice to have. It is not mandatory, so not CC-ed to stable,
> it just reduced the PnpId list.
>
> The good thing is that the reported min/max are correct, so the problems
> with the first generation of the t440 touchpad have been fixed now (and
> synaptics assured us that they will keep checking the quality of the PS/2
> handling of their touchpads).
>
> One last thing, I still did not manage to talk to the device over SMBus,
> so we are still stuck with the PS/2 protocol and its limitations for this
> series.

Series looks good to me and is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
