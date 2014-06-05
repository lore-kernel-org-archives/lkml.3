Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFEOxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:53:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:55736 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaFEOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:53:33 -0400
Message-ID: <53908467.8030100@redhat.com>
Date: Thu, 05 Jun 2014 16:53:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] KVM: x86: smsw emulation is incorrect in 64-bit mode
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il> <1401723251-8034-10-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1401723251-8034-10-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/06/2014 17:34, Nadav Amit ha scritto:
> In 64-bit mode, when the destination is a register, the assignment is done
> according to the operand size. Otherwise (memory operand or no 64-bit mode), a
> 16-bit assignment is performed.

I'm sorry, I'm missing the place where 64-bit mode is taken into account?

Paolo
