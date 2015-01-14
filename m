Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbbANSYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:24:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbbANSX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:23:59 -0500
Message-ID: <54B6B43A.9070506@redhat.com>
Date: Wed, 14 Jan 2015 13:23:54 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
References: <20150114171251.882318257@redhat.com> <20150114171459.694888126@redhat.com>
In-Reply-To: <20150114171459.694888126@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 12:12 PM, Marcelo Tosatti wrote:
> Since lapic timer handler only wakes up a simple waitqueue,
> it can be executed from hardirq context.
> 
> Reduces average cyclictest latency by 3us.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

