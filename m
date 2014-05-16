Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaEPVLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:11:31 -0400
Received: from www.sr71.net ([198.145.64.142]:51070 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbaEPVL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:11:29 -0400
Message-ID: <53767EFF.8060000@sr71.net>
Date: Fri, 16 May 2014 14:11:27 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
CC: dave.hansen@linux.intel.com, tglx@linutronix.de, x86@kernel.org,
        peterz@infradead.org, gleb@redhat.com, kvm@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH] x86: fix page fault tracing when KVM guest support enabled
References: <20140516194515.D859CC11@viggo.jf.intel.com> <53767AE6.5020202@zytor.com> <53767CBD.5010503@redhat.com>
In-Reply-To: <53767CBD.5010503@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 02:01 PM, Paolo Bonzini wrote:
> Yes, of course.  Dave, ok to only have it in 3.16?

Sure, it's been broken for a long time, so it's no hurry to get fixed.
