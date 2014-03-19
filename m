Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaCSIg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:36:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54711 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaCSIgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:36:54 -0400
Date: Wed, 19 Mar 2014 09:36:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 00/17 for-tip V3] A series patches about sched priority.
Message-ID: <20140319083644.GL22095@laptop.programming.kicks-ass.net>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I picked up all except:

 2 - whcih I don't think should go through a scheduler tree
 6 - its tools/ bits, the changelog wasn't clear if the MIN/MAX_NICE
      macros were uapi visible and I couldn't be bothered to figure it out.
 8 - I don't like the pointless macro

