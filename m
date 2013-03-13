Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3CMJ72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:59:28 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:36285 "EHLO mail.ku-gbr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3CMJ71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:59:27 -0400
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Konstantin Kletschke <lists@ku-gbr.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: when I/O happens on separate /var (ext4), __do_lookup_rcu always involved
References: <7x8v5thhl7.fsf@dell-01.ku-gbr.de>
Date: Wed, 13 Mar 2013 10:59:24 +0100
In-Reply-To: <7x8v5thhl7.fsf@dell-01.ku-gbr.de> (Konstantin Kletschke's
	message of "Mon, 11 Mar 2013 20:17:08 +0100")
Message-ID: <7xa9q71uyr.fsf@dell-01.ku-gbr.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

meanwhile I got memtest running on the machine after I moved it from its
headless setup to a place with keyboard and monitor. It turned out one
of the modules of the dual channel DDR3 memory kit throws an error after
a couple of seconds running on the same address, regardless which slot
it is placed in. The other module looks always okay...

So sorry for the inconvenience!

Konstantin Kletschke
