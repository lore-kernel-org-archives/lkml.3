Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3ANKL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:11:57 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57199 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3ANKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:11:56 -0500
Message-ID: <50F3D9E8.6040802@suse.cz>
Date: Mon, 14 Jan 2013 11:11:52 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: -next: no resume from suspend
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since friday's -next (the last known to be working is the last monday's)
I cannot resume from suspend. The last thing I see with
no_console_suspend is:
i915: No ACPI video bus found

But I used to see the message always, so this is no difference. Any idea
before I start bisecting?

It is x86_64, core 2 duo, intel g33 GPU, 6G RAM.

thanks,
-- 
js
suse labs
