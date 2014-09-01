Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaIAJX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:23:57 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40326 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaIAJXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:23:54 -0400
Date: Mon, 1 Sep 2014 11:23:30 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH 2/2] KVM: remove garbage arg to *hardware_{en,dis}able
Message-ID: <20140901092330.GE19836@cbox>
References: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
 <1409231583-7048-3-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409231583-7048-3-git-send-email-rkrcmar@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 03:13:03PM +0200, Radim Krčmář wrote:
> In the beggining was on_each_cpu(), which required an unused argument to
> kvm_arch_ops.hardware_{en,dis}able, but this was soon forgotten.
> 
> Remove unnecessary arguments that stem from this.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>

For the arm/arm64 part:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
