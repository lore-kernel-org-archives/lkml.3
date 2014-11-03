Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaKCQo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:44:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:54068 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaKCQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:44:55 -0500
Date: Mon, 3 Nov 2014 17:44:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Juergen Gross <jgross@suse.com>
cc: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH V6 10/18] x86: Remove looking for setting of _PAGE_PAT_LARGE
 in pageattr.c
In-Reply-To: <1415019724-4317-11-git-send-email-jgross@suse.com>
Message-ID: <alpine.DEB.2.11.1411031744280.5308@nanos>
References: <1415019724-4317-1-git-send-email-jgross@suse.com> <1415019724-4317-11-git-send-email-jgross@suse.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Juergen Gross wrote:

> When modifying page attributes via change_page_attr_set_clr() don't
> test for setting _PAGE_PAT_LARGE, as this is
> - never done
> - PAT support for large pages is not included in the kernel up to now
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
