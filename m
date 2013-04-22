Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3DVKX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:23:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3DVKXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:23:55 -0400
Message-ID: <1366626208.2721.12.camel@laptop>
Subject: Re: [PATCH] sched: wake-affine throttle
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 22 Apr 2013 12:23:28 +0200
In-Reply-To: <5164DCE7.8080906@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK,.. Ingo said that pipe-test was the original motivation for
wake_affine() and since that's currently broken to pieces due to
select_idle_sibling() is there still a benefit to having it at all?

Can anybody find any significant regression when simply killing
wake_affine()?


