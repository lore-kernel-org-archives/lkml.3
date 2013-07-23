Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3GWHwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:52:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:50128 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3GWHwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:52:16 -0400
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 09:52:15 +0200
Message-ID: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
Subject: [v3.11-rc2] regression: brightness always on maximum.
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: rafael.j.wysocki@intel.com, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness of my laptop is always on maximum and can't be scaled
down.
Brightness control via function keys was always working on this
laptop, so this is a regression in v3.11-rc2.

It is a FUJITSU LIFEBOOK AH532/FJNBB1C, BIOS Version 1.09 05/22/2012
Video driver is i915.

Please Cc me in answeres , I am not subscribed.

Thanks, Jörg
