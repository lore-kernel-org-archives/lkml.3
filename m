Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaBOLdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:33:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:46682 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBOLdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:33:36 -0500
Date: Sat, 15 Feb 2014 12:33:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 20/48] time: Replace __get_cpu_var uses
In-Reply-To: <20140214201906.012489314@linux.com>
Message-ID: <alpine.DEB.2.02.1402151232560.21991@ionos.tec.linutronix.de>
References: <20140214201841.826179349@linux.com> <20140214201906.012489314@linux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Christoph Lameter wrote:

> [Patch depends on another patch in this series that introduces raw_cpu_ops]
> 
> Convert uses of __get_cpu_var for creating a address from a percpu
> offset to this_cpu_ptr.
> 
> The two cases where get_cpu_var is used to actually access a percpu
> variable are changed to use this_cpu_read/raw_cpu_read.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
