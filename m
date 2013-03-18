Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3CRW4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab3CRW4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:56:46 -0400
Date: Mon, 18 Mar 2013 18:04:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linaro-kernel@lists.linaro.org,
        Gleb Natapov <gleb@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
Message-ID: <20130318210418.GB16985@amt.cnet>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363306426-27209-1-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 05:13:46PM -0700, Kevin Hilman wrote:
> The new context tracking subsystem unconditionally includes kvm_host.h
> headers for the guest enter/exit macros.  This causes a compile
> failure when KVM is not enabled.
> 
> Fix by adding an IS_ENABLED(CONFIG_KVM) check to kvm_host so it can
> be included/compiled even when KVM is not enabled.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> Applies on v3.9-rc2
> 
>  include/linux/kvm_host.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied and queued for v3.9, thanks.

