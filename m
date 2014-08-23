Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaHWUBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 16:01:03 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:53119 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbaHWUBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 16:01:01 -0400
Date: Sat, 23 Aug 2014 15:00:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <20140823171416.GG13540@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408231500430.31459@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org> <20140821222212.GA7996@mtj.dyndns.org> <alpine.DEB.2.11.1408212001100.19762@gentwo.org> <20140822164051.GB15713@mtj.dyndns.org> <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
 <20140823171416.GG13540@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2014, Tejun Heo wrote:

> Hello, Christoph.
>
> On Fri, Aug 22, 2014 at 12:43:25PM -0500, Christoph Lameter wrote:
> > It wont accept the wrong type since the this_cpu_* functions will do type
> > checking.
>
> It should only accept cpumask_var_t but the macro version accepts
> anything that this_cpu_*() can handle.

Ah, Ok.

