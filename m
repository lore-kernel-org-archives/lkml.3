Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaCEVFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:05:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42519 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaCEVFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:05:32 -0500
Date: Wed, 5 Mar 2014 13:05:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86, fix defined for VECTOR_UNDEFINED and
 VECTOR_RETRIGGERED
In-Reply-To: <1394050246-28453-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1403051305130.22928@chino.kir.corp.google.com>
References: <1394050246-28453-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Prarit Bhargava wrote:

> During another patch review, David Rientjes noted that VECTOR_UNDEFINED
> and VECTOR_RETRIGGERED should be defined with ()s so that they are not
> erroneously used in an arithmetic operation.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Yang Zhang <yang.z.zhang@Intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
