Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3KABjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 21:39:03 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:41961 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3KABjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 21:39:00 -0400
X-Greylist: delayed 1976 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2013 21:39:00 EDT
Message-ID: <5272FE79.30801@tlinx.org>
Date: Thu, 31 Oct 2013 18:06:01 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: RFE?: why no 'bind' info in /proc/mounts?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If I only mount 1 file (or a subdir) via "bind", it still shows the entire
device being mounted on the "bound" directory.

Is there anyway to get a bit more granularity as to *what* was
bound on a name?  (subdir/file..?)


