Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3J2Wgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:36:35 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35706 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3J2Wge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:36:34 -0400
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 23:36:33 +0100
Message-ID: <CA+MoWDqEv0vxU3erx9GCuJAzK73U+WiuMwY71t94WB6HH-264A@mail.gmail.com>
Subject: Suspend / Resume broken on Toshiba R830 / R700
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jiang Liu <jiang.liu@huawei.com>, Toshi Kani <toshi.kani@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one Toshiba R830 and one R700 and suspend / resume is broken on
both. I've filled a bug report[1] on 03/02/2012, and it is still not
fixed.

It apparently suspend well and start resuming, but then something goes
wrong, the screen keeps black and the CPU fan goes full speed.

I suspect that this affects a considerable large number of devices.

I'm looking for fixing it. Can anyone point me some directions?

Thank you,

Peter

[1] https://bugzilla.redhat.com/show_bug.cgi?id=787299

-- 
Peter
