Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaLGUm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:42:56 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64683 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaLGUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:42:51 -0500
Message-ID: <5484BBC8.7080304@linaro.org>
Date: Sun, 07 Dec 2014 21:42:48 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [question] on which cpu an interrupt controller will raise an irq
 ?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I am not very familiar with the interrupt subsystem, so sorry if this 
sounds a stupid question.

IIUC, when a interrupt happens on a SMP system and if there is no 
affinity set for it, it is delivered following a scheme decided by the 
interrupt controller.

For example, for the APIC, there is a round robin behaviour, so an 
interrupt will be raised on cpu0, then cpu1, and so on ...

Is there a way to know on which cpu a controller will raise the interrupt ?

Thanks in advance

   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

