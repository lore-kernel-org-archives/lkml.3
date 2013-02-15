Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3BOSfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:35:33 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47839 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3BOSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:35:31 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com> <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
 <20130215174435.GA2792@linux.vnet.ibm.com> <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Feb 2013 10:35:10 -0800
X-Google-Sender-Auth: nusdQqmlI4lDnOb3AowZaB6iAls
Message-ID: <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:34 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Something like this ENTIRELY UNTESTED patch.

.. and let's actually attach the patch this time.

                      Linus
