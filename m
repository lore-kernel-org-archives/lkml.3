Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3FEQ02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:26:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3FEQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:26:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Please backport bee980d9e9642e96351fa3ca9077b853ecf62f57 (xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.) to earlier kernels v3.8...and so on
References: <20130603120232.GA6893@phenom.dumpdata.com>
Date: Wed, 05 Jun 2013 17:26:22 +0100
In-Reply-To: <20130603120232.GA6893@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Mon, 3 Jun 2013 08:02:32 -0400")
Message-ID: <87zjv4h6c1.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> Hey Greg,
>
> I hadn't (by mistake) put the CC: stable@vger.kernel.org on said patch
> (Which is in the Linux kernel).
>
> If possible please back-port said patch to the existing stable trees.
> Attached is a version that applies to some of the earlier trees easily.
>
>

Thanks, I'm queuing it to the 3.5 kernel as well.

Cheers,
-- 
Luis
