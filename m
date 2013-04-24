Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3DXIy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:54:28 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:54881 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab3DXIyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:54:25 -0400
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 16:54:24 +0800
Message-ID: <CACbbJybvwP5aAWw37k_OX4P15H2cH9tM2R9OaqEcx0-C37svRg@mail.gmail.com>
Subject: [HELP] cpuidle in SYSFS: /sys/devices/system/cpu/cpu0/cpuidle/state0/desc
From: Ren Zhen <darwin.xupt@gmail.com>
To: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
In /Documentation/cpuidle/sysfs.txt, It says:
"desc : Small description about the idle state(string)".

when I read desc:
------------------------------------------------------------------------
mysystem:/sys/devices/system/cpu/cpu0/cpuidle/state0/# cat desc
CPUIDLE CORE POLL IDLE
------------------------------------------------------------------------

Here is my question:What the meaning of  ‘CPUIDLE CORE POLL IDLE'?

Any help will be appreciated!
--
Sincerely,
Ren Zhen
