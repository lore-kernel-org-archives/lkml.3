Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966721Ab3HILuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:50:50 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:59156 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965439Ab3HILus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:50:48 -0400
Message-ID: <5204D776.6040903@redhat.com>
Date: Fri, 09 Aug 2013 13:50:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/3] mips/kvm: Code cleanups for kvm_locore.S
References: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/08/2013 22:22, David Daney ha scritto:
> From: David Daney <david.daney@cavium.com>
> 
> These shouldn't be too controversial, they just clean things up
> without changing the generated code.
> 
> More substantial patches will follow, but it seemed like a good idea
> to clean this up first.
> 
> David Daney (3):
>   mips/kvm: Improve code formatting in arch/mips/kvm/kvm_locore.S
>   mips/kvm: Cleanup .push/.pop directives in kvm_locore.S
>   mips/kvm: Make kvm_locore.S 64-bit buildable/safe.
> 
>  arch/mips/kvm/kvm_locore.S | 965 ++++++++++++++++++++++-----------------------
>  1 file changed, 480 insertions(+), 485 deletions(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
