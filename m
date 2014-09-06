Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaIFTIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:08:25 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44220 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaIFTIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:08:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] memfd: Add memfd.h to uapi headers
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CANq1E4QFLW3RdNTnQmmyiDNDQg-m5zCP_mL1tRJuRD=cZtW8Xw@mail.gmail.com>
Date: Sat, 6 Sep 2014 12:08:49 -0700
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3FBD6ED1-82F5-4D47-BDA8-2506129E4A44@holtmann.org>
References: <1410028833-31840-1-git-send-email-marcel@holtmann.org> <CANq1E4QFLW3RdNTnQmmyiDNDQg-m5zCP_mL1tRJuRD=cZtW8Xw@mail.gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>> It seems like a good idea to actually expose include/uapi/linux/memfd.h
>> so that it gets installed and can be used by userspace.
>> 
>> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> 
> Already in -mmots, will probably be pulled by Linus next week:
> 
> http://ozlabs.org/~akpm/mmots/broken-out/shm-add-memfdh-to-uapi-export-list.patch

might be a good idea to get it in before 3.17-rc4 and not have it dangling around for another week. Just an idea ;)

Regards

Marcel

