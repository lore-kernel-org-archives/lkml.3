Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaA3NCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:02:55 -0500
Received: from mail.southpole.se ([37.247.8.11]:50156 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaA3NCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:02:54 -0500
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2014 08:02:54 EST
Message-ID: <52EA4905.2050400@southpole.se>
Date: Thu, 30 Jan 2014 13:43:49 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] OpenRISC updates for 3.14
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13335) on assp.southpole.se
X-Assp-ID: assp.southpole.se 85829-12862
X-Assp-Session: 7FD57281F318 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

   Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

   git://openrisc.net/~jonas/linux tags/for-3.14

for you to fetch changes up to 548dafe880ad84d0accc0a5596c26e3348b103e1:

   openrisc: Use get_signal() signal_setup_done() (2014-01-09 10:57:21 
+0100)

----------------------------------------------------------------
OpenRISC updates for 3.14

The interesting change here is a rework of the OpenRISC signal handling
to make it more like other architectures in the hopes that this
makes it easier for others to comment on and understand.  This
rework fixes some real bugs, like the fact that syscall restart
did not work reliably.

----------------------------------------------------------------
Jonas Bonn (1):
       openrisc: Rework signal handling

Richard Weinberger (1):
       openrisc: Use get_signal() signal_setup_done()

  arch/openrisc/kernel/entry.S  |  59 ++++++-----
  arch/openrisc/kernel/signal.c | 233 
+++++++++++++++++++++---------------------
  2 files changed, 149 insertions(+), 143 deletions(-)
