Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaLHU2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:28:31 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:58946 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbaLHU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:28:29 -0500
Message-ID: <1418070507.2058.46.camel@x220>
Subject: Re: [PATCH 1/3] kconfig: regenerate parser
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com
Date: Mon, 08 Dec 2014 21:28:27 +0100
In-Reply-To: <0bf50ad9bc78f6944ebf5d5b1f8c9bdff223185f.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
	 <0bf50ad9bc78f6944ebf5d5b1f8c9bdff223185f.1418003065.git.cj@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 20:28:27.0520 (UTC) FILETIME=[85EA8000:01D01325]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-07 at 20:49 -0500, Christoph Jaeger wrote:
> Regenerate the Kconfig parser with Bison 3.0.2 in preparation for a following

Nit: could you please add the exact command line too? 

> commit. Otherwise the changes caused by the more recent Bison version would be
> intermingled with functional changes.
> 
> Signed-off-by: Christoph Jaeger <cj@linux.com>
> ---

Are there any downsides to regenerating using, what looks like, a
current version of bison? I'm not aware there are.

I've tested this on all 463 defconfig files in next-20141208. None of
the generated .config files changed. So this patch is:
    Tested-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle

