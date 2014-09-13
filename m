Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaIMJj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:39:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:52435 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaIMJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:39:58 -0400
Date: Sat, 13 Sep 2014 11:39:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] Intel MPX support
In-Reply-To: <54136EC4.6000905@intel.com>
Message-ID: <alpine.DEB.2.10.1409131138290.23397@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <54124379.5090502@intel.com> <alpine.DEB.2.10.1409121543090.4178@nanos> <54136EC4.6000905@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Dave Hansen wrote:

> OK, here's some revised text for patch 00/10.  Again, this will
> obviously be updated for the next post, but comments before that would
> be much appreciated.

That looks good. So much of this wants to end up in documentation as
well.

Thanks,

	tglx
