Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaFMHfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:35:20 -0400
Received: from purkki.adurom.net ([80.68.90.206]:34046 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaFMHfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:35:19 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] video: X sets brightness to zero after resume
References: <871tuu1epc.fsf@purkki.adurom.net> <539A53B3.6030902@intel.com>
	<539AA863.6070806@redhat.com>
Date: Fri, 13 Jun 2014 10:35:15 +0300
In-Reply-To: <539AA863.6070806@redhat.com> (Hans de Goede's message of "Fri,
	13 Jun 2014 09:29:39 +0200")
Message-ID: <87wqclz2h8.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

>>> If I set video.use_native_backlight=0 in kernel command line the problem
>>> goes away. Or if I revert your commit 0e9f81d3b7c the problem also goes
>>> away. Any ideas?
>> 
>> Not really...
>> I've added i915 people maybe they have an idea.
>
> This is a known issue in xf86-video-intel, which gets exposed due to the
> video.use_native_backlight=1 option. This should be fixed in the latest 2.99.912
> xf86-video-intel release.

Ok, thanks. As Ubuntu 12.04 doesn't have that I'll continue to use
video.use_native_backlight=0 until I update my distro.

-- 
Kalle Valo
