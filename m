Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3ETWgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 18:36:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60978 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3ETWgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 18:36:10 -0400
Message-ID: <519AA53F.1020107@zytor.com>
Date: Mon, 20 May 2013 15:35:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <greg@kroah.com>
Subject: Get rid of cpuinit?
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have gotten rid of devinit markup.  A recent patch of Linus' makes me
wonder if we similarly should get rid of cpuinit markup?

Just as with devices, the CPU hotplug machinery has been leveraged to
support a number of pieces of functionality such as suspend, which means
that on anything but the most embedded systems this functionality is
likely needed anyway.

On x86-64, for an "allyesconfig" build, the total amount of space in all
the .cpu* sections combined is 100K.

	-hpa
