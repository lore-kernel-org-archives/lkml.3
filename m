Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3G3Uq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:46:59 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:65168 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab3G3Uq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:46:57 -0400
Message-Id: <20130730204154.407090410@gmail.com>
User-Agent: quilt/0.60-1
Date: Wed, 31 Jul 2013 00:41:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, gorcunov@openvz.org,
        xemul@parallels.com, akpm@linux-foundation.org, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [patch 0/2] Soft-dirty page tracker improvemens
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, as being reported by Andy, there are a couple of situations
when soft-dirty bit will be lost, in paricular when page we're
tracking is going to swap and when file page get reclaimed. In
this series both problems are aimed.

One more hardness which remains is the scenario when vma area
(which has soft-dirty bit set in appropriate pte entries) get
unmapped then new one mapped in-place. I'm working on it now
hope to provide a patch soon.

Thanks,
	Cyrill
