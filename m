Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbbATHRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:17:15 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:62723 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbATHRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:17:12 -0500
Message-ID: <54BE00F6.9000900@lwfinger.net>
Date: Tue, 20 Jan 2015 01:17:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, intel-gfx@lists.freedesktop.org,
        "dri-devel@lists.freedesktop.org >> DRI" 
	<dri-devel@lists.freedesktop.org>
Subject: Logged messages from i915 using kernel 3.19-rc4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just discovered almost 100 of the following entries in my log:

[drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed register before interrupt

Those were accumulated in about 12 hours of operation. I also have one that says

i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment

The above output was in the middle of the other type.

The "lspci -nnv" stanza for the i915 is:

00:02.0 VGA compatible controller [0300]: Intel Corporation 4th Gen Core 
Processor Integrated Graphics Controller [8086:0416] (rev 06) (prog-if 00 [VGA 
controller])
         Subsystem: Toshiba America Info Systems Device [1179:0002]
         Flags: bus master, fast devsel, latency 0, IRQ 31
         Memory at e0000000 (64-bit, non-prefetchable) [size=4M]
         Memory at d0000000 (64-bit, prefetchable) [size=256M]
         I/O ports at 4000 [size=64]
         Expansion ROM at <unassigned> [disabled]
         Capabilities: <access denied>
         Kernel driver in use: i915
         Kernel modules: i915

Please let me know of any further info that you need, or any diagnostics that I 
can add.

Thanks,

Larry
