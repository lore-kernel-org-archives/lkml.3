Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3JaK7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab3JaK7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:59:32 -0400
Message-ID: <5272380F.9000600@redhat.com>
Date: Thu, 31 Oct 2013 11:59:27 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] Documentation/kvm: patches should be against linux.git
References: <1383216396-12869-1-git-send-email-artagnon@gmail.com> <1383216396-12869-3-git-send-email-artagnon@gmail.com>
In-Reply-To: <1383216396-12869-3-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2013 11:46, Ramkumar Ramachandra ha scritto:
> The document hasn't been updated since cf3e3d3 (KVM: Document KVM
> specific review items, 2010-06-24); kvm does not have a separate
> repository anymore.

Maintainer have their repository at
git://git.kernel.org/pub/scm/virt/kvm/kvm.git.  The right fix is to add
that tree to MAINTAINERS.

Paolo

> Cc: Avi Kivity <avi@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  Documentation/virtual/kvm/review-checklist.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/review-checklist.txt b/Documentation/virtual/kvm/review-checklist.txt
> index a850986..8385c4d 100644
> --- a/Documentation/virtual/kvm/review-checklist.txt
> +++ b/Documentation/virtual/kvm/review-checklist.txt
> @@ -4,7 +4,7 @@ Review checklist for kvm patches
>  1.  The patch must follow Documentation/CodingStyle and
>      Documentation/SubmittingPatches.
>  
> -2.  Patches should be against kvm.git master branch.
> +2.  Patches should be against linux.git master branch.
>  
>  3.  If the patch introduces or modifies a new userspace API:
>      - the API must be documented in Documentation/virtual/kvm/api.txt
> 

