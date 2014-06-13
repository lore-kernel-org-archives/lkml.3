Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaFMRKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:10:40 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:55764 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaFMRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:10:39 -0400
Date: Fri, 13 Jun 2014 12:10:36 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 02/12] percpu: introduce arch_raw_cpu_ptr()
In-Reply-To: <1402590209-31610-3-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.10.1406131209540.1717@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-3-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Tejun Heo wrote:

> Currently, archs can override raw_cpu_ptr() directly; however, we
> wanna build a layer of indirection in the generic part of percpu so
> that we can implement generic features there without affecting archs.

Not sure why one would do this. We already have this_cpu_ptr() (arch
independant) and the lower level raw_cpu_ptr() which can be modified by
the arch code.

