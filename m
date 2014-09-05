Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaIEVAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:00:46 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51323 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaIEVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:00:45 -0400
Message-ID: <540A2474.7060306@redhat.com>
Date: Fri, 05 Sep 2014 23:00:36 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos> <5408D815.9090105@redhat.com> <alpine.DEB.2.10.1409050000570.3333@nanos> <5409E755.4040905@redhat.com> <alpine.DEB.2.10.1409052031140.5472@nanos> <540A1F22.7020107@redhat.com> <alpine.DEB.2.10.1409052239330.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409052239330.5472@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/09/2014 22:41, Thomas Gleixner ha scritto:
> No, it needs to be above update_vsyscall(). Here is the patch again
> which I sent before. [https://lkml.org/lkml/2014/9/5/395]

Ah, I missed it after your signature.  Thanks, I'll test yours then next
week.

Paolo
