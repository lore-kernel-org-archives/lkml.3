Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3EUXDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3EUXDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:03:40 -0400
Date: Tue, 21 May 2013 19:03:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: microcode loading got really slow.
Message-ID: <20130521230332.GC12713@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 3.10-rc2 I see this happening..

[   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
[  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
[  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
[  252.702055] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

For some reason the events for udev seem to be getting delayed 60s for each core.

	Dave

