Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3JUMc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:32:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3JUMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <52651D8C.3090203@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
	<1382304926-1641-3-git-send-email-prarit@redhat.com>
	<CACVXFVMjEnkk8zYycsk6t4WiWOJ_NT1AKFoK7p5mQnFkw9KE-g@mail.gmail.com>
	<52651D8C.3090203@redhat.com>
Date: Mon, 21 Oct 2013 20:32:52 +0800
Message-ID: <CACVXFVOqM6BLv914G-PHyYXZR4-wqgosdLUiF=KuESx2+8UQ2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] intel_microcode, Fix long microcode load time when
 firmware file is missing
From: Ming Lei <ming.lei@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        herrmann.der.user@googlemail.com, tigran@aivazian.fsnet.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 8:26 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>
>> And why don't you pass FW_ACTION_HOTPLUG? and you are sure
>> that udev isn't required to handle your microcode update request?
>>
>
> AFAICT in both cases, udev wasn't required to handle the cpu microcode update.
> Both drivers use CMH to load the firmware which removes the need for udev to do
> anything.  Admittedly maybe I've missed some odd use case but I don't think it
> is necessary.

OK, so I guess the CMH still need uevent to get notified, right?

If yes, you should take FW_ACTION_HOTPLUG.


Thanks,
--
Ming Lei
