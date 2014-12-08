Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaLHTOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:14:05 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:52889 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbaLHTOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:14:03 -0500
Message-ID: <1418066039.2058.19.camel@x220>
Subject: Re: [PATCH 2/3] kconfig: remove undocumented type definition alias
 'boolean'
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com
Date: Mon, 08 Dec 2014 20:13:59 +0100
In-Reply-To: <1418064660.2058.11.camel@x220>
References: <cover.1418003065.git.cj@linux.com>
	 <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>
	 <1418064660.2058.11.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 19:13:59.0801 (UTC) FILETIME=[1EF2AE90:01D0131B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 19:51 +0100, Paul Bolle wrote:
> This doesn't apply on next-20141208. What tree did you base this on?

I got it to apply on next-20141208 by dropping the hunk for
arch/cris/arch-v32/drivers/Kconfig and by making (trivial) context
changes to the hunks for init/Kconfig and net/Kconfig.

(My experience with actual maintainers is that they won't bother to do
that. Anyhow, Kconfig is basically unmaintained. And I don't know which
tree one should base ones Kconfig patches on.)

I'll muddle along...


Paul Bolle

