Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaG1Pz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:55:58 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:33845
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbaG1Pzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:55:54 -0400
Date: Mon, 28 Jul 2014 10:55:35 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        bp@alien8.de, linux@arm.linux.org.uk, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, davem@davemloft.net, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 35/70] mm, slab: _FROZEN Cleanup
In-Reply-To: <1406080786-3938-36-git-send-email-gong.chen@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1407281055200.13286@gentwo.org>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com> <1406080786-3938-36-git-send-email-gong.chen@linux.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Chen, Gong wrote:

> Remove XXX_FROZEN state from mm/slab.

Acked-by: Christoph Lameter <cl@linux.com>
