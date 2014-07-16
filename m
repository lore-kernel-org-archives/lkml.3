Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaGPTub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:50:31 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:49993 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbaGPTu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:50:27 -0400
Message-ID: <1405540224.4408.55.camel@x220>
Subject: Re: [PATCH v2 29/29] nios2: Build infrastructure
From: Paul Bolle <pebolle@tiscali.nl>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Date: Wed, 16 Jul 2014 21:50:24 +0200
In-Reply-To: <1405413956-2772-30-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	 <1405413956-2772-30-git-send-email-lftan@altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 19:50:25.0082 (UTC) FILETIME=[2F9459A0:01CFA12F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ley Foon,

On Tue, 2014-07-15 at 16:45 +0800, Ley Foon Tan wrote:
> This patch adds Makefile and Kconfig files required for building a
> nios2 kernel.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

For what it's worth, this v2 indeed cleans up the few things I noted in
the related 01/28 of v1.

So this series doesn't introduce any new Kconfig related oddities
anymore; ie, oddities of the obvious type that my local script spots.
That can't qualify as a review but I do think it's nice to see.

Thanks,


Paul Bolle

