Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3DSJQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:16:41 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41167 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab3DSJQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:16:39 -0400
Message-ID: <51710B74.9020401@suse.cz>
Date: Fri, 19 Apr 2013 11:16:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: 3.9.0-rc7-next: i915: render error detected
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, with today's -next I got this:

[drm] capturing error event; look for more information in
/sys/kernel/debug/dri/0/i915_error_state
i915: render error detected, EIR: 0x00000010
i915: page table error
i915:   PGTBL_ER: 0x00000002
[drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
i915: render error detected, EIR: 0x00000010
i915: page table error
i915:   PGTBL_ER: 0x00000002


The error state is here:
http://www.fi.muni.cz/~xslaby/sklad/panics/i915_error_state

thanks,
-- 
js
suse labs
