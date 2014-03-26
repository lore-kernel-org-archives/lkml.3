Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaCZREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:04:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41017 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbaCZREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140326165038.GD24604@oranje.fc.hp.com>
References: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
	<20140325200352.GU31785@oranje.fc.hp.com>
	<CAE9FiQUxBWFfUBjdsakPV0B=rsB4wD-sX6Q2tVbOjNy9RJffRg@mail.gmail.com>
	<20140326165038.GD24604@oranje.fc.hp.com>
Date: Wed, 26 Mar 2014 10:04:52 -0700
X-Google-Sender-Auth: z_NlD_uGriFFBDzO8VyFHw8BE0I
Message-ID: <CAE9FiQUidLDFunEKpVPfSppO1qOzpVPMXW5utd939RdLLei_Fg@mail.gmail.com>
Subject: Re: [PATCH v3] x86, irq: get correct available vectors for cpu disable
From: Yinghai Lu <yinghai@kernel.org>
To: Linn Crosetto <linn@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 9:50 AM, Linn Crosetto <linn@hp.com> wrote:
> On Tue, Mar 25, 2014 at 05:18:53PM -0700, Yinghai Lu wrote:
>
> Just noting that not all bits above first_system_vector are set in the bitmap,
> so the comment in asm/desc.h and the change log could be misleading:
>
> /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
>

Do you mean some vector that is neither used by percpu_vector_irq nor
system_vector
after first_system_vector ?

Anyway if bit is set in used_vectors, that vector can not be used by
percpu vector_irq.

so that statement looks still right.

Feel free to suggest right comment or changelog.

> I have tested and the patch itself is good.

Good.

Thanks

Yinghai
