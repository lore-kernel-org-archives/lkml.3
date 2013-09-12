Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3ILQcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:32:53 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37202 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3ILQcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:32:52 -0400
Message-ID: <5231ECBA.7060801@redhat.com>
Date: Thu, 12 Sep 2013 18:32:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2] kvm: fix a bug and remove a redundancy in async_pf
References: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2013 22:32, Radim Krčmář ha scritto:
> I did not reproduce the bug fixed in [1/2], but there are not that many
> reasons why we could not unload a module, so the spot is quite obvious.
> 
> 
> Radim Krčmář (2):
>   kvm: free resources after canceling async_pf
>   kvm: remove .done from struct kvm_async_pf
> 
>  include/linux/kvm_host.h | 1 -
>  virt/kvm/async_pf.c      | 8 ++++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 

Applied to kvm-queue; patch 1 will go in 3.12, patch 2 won't.

Paolo
