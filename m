Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3IPLjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:39:35 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:44551 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3IPLje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:39:34 -0400
Message-ID: <5236EDEB.8030604@t-online.de>
Date: Mon, 16 Sep 2013 13:39:23 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Regression 3.11.0+] shrink_slab: i915_gem_inactive_scan+0x0/0x9c
 negative objects to delete nr=-xxxx
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: X6bwBwZ-ohUyNuZitzsCotOC0OS-YCnjKwD9q+npfZFbFBRB6v6fzUlBwnoE+57wBP
X-TOI-MSGID: cfa195dc-5833-431c-b519-5582746c5f4f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody!

Since Sep 13 linux git master kernels started to complain about a new problem:
"shrink_slab: i915_gem_inactive_scan+0x0/0x9c negative objects to delete nr=<negative number>"

Hardware: Aopen i915GMm-hfs, Pentium M, 2GB RAM

More information available on request.

cu,
  Knut
