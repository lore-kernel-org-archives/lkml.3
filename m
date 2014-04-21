Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaDUQwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:52:24 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:33567 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:52:18 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 12:52:18 EDT
Message-ID: <53554B59.8080107@t-online.de>
Date: Mon, 21 Apr 2014 18:46:17 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: intel-gfx <intel-gfx@lists.freedesktop.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Bug 3.15-rc2] intel framebuffer broken
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: G5IsbQZOZhT4uPqC1cJNloOevmUJYtE0JfG4Fb3+Dk1+IWslAQwFBSuSb0SVslFgxt
X-TOI-MSGID: e9d63416-d747-4fa5-9bc1-978595238738
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting kernel 3.15-rc2 on an AOpen i915GMm-hfs, I see the framebuffer broken.
Only about the upper left quarter of the monitor is used for displaying the boot messages,
these (and the cursor) are replicated at the right of that area.
Approximately the lower half of the monitor stays black. The output of the xserver
is not affected.

cu,
  Knut



