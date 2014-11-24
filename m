Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaKXKpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:45:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:37176 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKXKpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:45:11 -0500
Date: Mon, 24 Nov 2014 11:45:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] KVM: x86: export get_xsave_addr
In-Reply-To: <1416823471-30846-1-git-send-email-pbonzini@redhat.com>
Message-ID: <alpine.DEB.2.11.1411241144220.6439@nanos>
References: <1416823471-30846-1-git-send-email-pbonzini@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Paolo Bonzini wrote:
> get_xsave_addr is the API to access XSAVE states, and KVM would
> like to use it.  Export it.
> 
> Cc: x86@kernel.org
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Peter, can you please ACK this for inclusion in the KVM tree?

Are you content with my acked-by as well?

Acked-by: Thomas Gleixner <tglx@linutronix.de>

