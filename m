Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947566Ab3BIAdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:33:03 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:59101 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947344Ab3BIAdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:33:01 -0500
Message-ID: <51159938.2080903@linaro.org>
Date: Fri, 08 Feb 2013 16:32:56 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>
Subject: [GIT PULL] time: One more change for 3.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Wanted to get one more change queued for 3.9 from Prarit. Let me 
know if you have any objections.

thanks
-john

The following changes since commit 6f16eebe1ff82176339a0439c98ebec9768b0ee2:

   timekeeping: Switch HAS_PERSISTENT_CLOCK to 
ALWAYS_USE_PERSISTENT_CLOCK (2013-01-29 14:40:12 -0800)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.9/time

for you to fetch changes up to 84e345e4e209cbe796c88fa2ad1732d7121ec100:

   time, Fix setting of hardware clock in NTP code (2013-02-08 15:07:05 
-0800)

----------------------------------------------------------------
Prarit Bhargava (1):
       time, Fix setting of hardware clock in NTP code

  include/linux/time.h |    1 +
  kernel/time.c        |    8 ++++++++
  kernel/time/ntp.c    |    8 ++++++--
  3 files changed, 15 insertions(+), 2 deletions(-)
