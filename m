Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab3CHDzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:55:04 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:57900
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760306Ab3CHDyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:54:54 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.229;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail02v.am.sony.com;RD:mail02.sonyusa.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z21eIzda00hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h947hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1b0ah1155h)
Message-ID: <51396107.3010003@am.sony.com>
Date: Thu, 7 Mar 2013 19:54:47 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>, <rostedt@goodmis.org>
Subject: linux-3.4.33-rt47 smoke test on ARM
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-3.4.33-rt47 builds and boots on some ARM boards (PandaBoard, Realview) for:

  - SMP, PREEMPT_RT_FULL
  - SMP, PREEMPT_NONE
  - UP, PREEMPT_RT_FULL
  - UP, PREEMPT_NONE

-Frank

