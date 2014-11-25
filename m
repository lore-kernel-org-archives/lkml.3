Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaKYTPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:15:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:14:59 -0500
Message-ID: <5474D476.3020506@redhat.com>
Date: Tue, 25 Nov 2014 14:11:50 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
References: <20141125172108.992070524@redhat.com> <20141125172329.580701786@redhat.com>
In-Reply-To: <20141125172329.580701786@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 12:21 PM, Marcelo Tosatti wrote:
> Since lapic timer handler only wakes up a simple waitqueue,
> it can be executed from hardirq context.
> 
> Reduces average cyclictest latency by 3us.

Can this patch be merged in the KVM tree, and go
upstream via Paolo?

> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

