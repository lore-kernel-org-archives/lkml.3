Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaIJOll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:41:41 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:49078 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaIJOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140910143019.GA3771@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
	<1409926097-2101-2-git-send-email-bhe@redhat.com>
	<CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
	<20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
	<CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
	<20140909192813.GB9435@redhat.com>
	<20140910072115.GA31685@dhcp-16-116.nay.redhat.com>
	<20140910143019.GA3771@redhat.com>
Date: Wed, 10 Sep 2014 07:41:38 -0700
X-Google-Sender-Auth: -qAIibQPyE8VrPrLjPz5xJD7KGs
Message-ID: <CAGXu5jLTd=xvhjiSGsp5FiT7w0cSctZF2KPOvfU=1_R8Up-97w@mail.gmail.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle relocations
From: Kees Cook <keescook@chromium.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> So I would suggest that test and repost the other patch with proper changelog
> and that might be sufficient for now. Only other thing we will need is
> Kees's patch for avoiding setup data regions in kaslr.

If someone can confirm that my patch works, I can request x86 pull it.

Currently living here:
https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
