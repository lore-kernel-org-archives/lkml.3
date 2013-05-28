Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3E1Uul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:50:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57246 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3E1Uuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:50:39 -0400
Message-ID: <51A5189D.3040004@linaro.org>
Date: Tue, 28 May 2013 13:50:37 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Time fixes for 3.10
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Just two small time fixes for 3.10 I wanted to send your way.

thanks
-john



The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

   Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.10/time

for you to fetch changes up to 0d6bd9953f739dad96d9a0de65383e479ab4e10d:

   timekeeping: Correct run-time detection of persistent_clock. 
(2013-05-28 13:45:19 -0700)

----------------------------------------------------------------
Geert Uytterhoeven (1):
       ntp: Remove unused variable flags in __hardpps

Zoran Markovic (1):
       timekeeping: Correct run-time detection of persistent_clock.

  kernel/time/ntp.c         | 1 -
  kernel/time/timekeeping.c | 8 ++++++++
  2 files changed, 8 insertions(+), 1 deletion(-)
