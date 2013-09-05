Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3IERwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:52:23 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:48408 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab3IERwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:52:21 -0400
Date: Thu, 5 Sep 2013 17:52:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Will Deacon <will.deacon@arm.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
In-Reply-To: <20130905172810.GB29219@mudshark.cambridge.arm.com>
Message-ID: <00000140ef40d3fc-55c44dfd-7403-43f4-b1fb-d116c55be5a6-000000@email.amazonses.com>
References: <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com> <20130904142324.GD3643@mudshark.cambridge.arm.com> <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com> <20130904174624.GB5599@mudshark.cambridge.arm.com>
 <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com> <20130904182113.GD5599@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1309041324530.26497@gentwo.org> <00000140eac4f5fc-9f8c86db-05dd-496f-abf8-63ca3667574f-000000@email.amazonses.com>
 <20130905130359.GA22351@mudshark.cambridge.arm.com> <00000140ee828138-3328099b-149e-433d-8262-0a481806ca85-000000@email.amazonses.com> <20130905172810.GB29219@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.05-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013, Will Deacon wrote:

> > Ok can you take it from here and modify it? I have no build and test
> > environment set up for ARM.
>
> Sure. Does that include the original arm/arm64 patches from your v3 series
> as well as these two fixups?

I think so. Take whatever you can and I will make another pass after the
merge and pick up anything that was missed.

