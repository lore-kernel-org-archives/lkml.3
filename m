Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaK3KGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:06:40 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35275 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaK3KGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:06:39 -0500
Date: Sun, 30 Nov 2014 11:07:18 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: arm: vgic: Let one looping code instead of two
 looping code
Message-ID: <20141130100718.GA484@cbox>
References: <547A9A7C.1080508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547A9A7C.1080508@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 12:18:04PM +0800, Chen Gang wrote:
> Use one looping instead of two, so can let code more simpler and get a
> little better performance.
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Performance?  Please, this is vgic_create....

This does nothing else than introduce churn.

-Christoffer
