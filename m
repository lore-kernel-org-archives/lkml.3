Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3IHIeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 04:34:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab3IHId6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 04:33:58 -0400
Date: Sun, 8 Sep 2013 11:33:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] kvm: fix a bug and remove a redundancy in async_pf
Message-ID: <20130908083355.GA17294@redhat.com>
References: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:32:22PM +0200, Radim Krčmář wrote:
> I did not reproduce the bug fixed in [1/2], but there are not that many
> reasons why we could not unload a module, so the spot is quite obvious.
> 
> 
Reviewed-by: Gleb Natapov <gleb@redhat.com>

> Radim Krčmář (2):
>   kvm: free resources after canceling async_pf
>   kvm: remove .done from struct kvm_async_pf
> 
>  include/linux/kvm_host.h | 1 -
>  virt/kvm/async_pf.c      | 8 ++++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> -- 
> 1.8.3.1

--
			Gleb.
