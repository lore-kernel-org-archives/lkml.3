Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaCKANn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:13:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:13542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbaCKANm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,627,1389772800"; 
   d="scan'208";a="495800338"
Message-ID: <531E5531.20409@linux.intel.com>
Date: Mon, 10 Mar 2014 17:13:37 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
CC: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove compat vdso support
References: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
In-Reply-To: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 05:12 PM, Andy Lutomirski wrote:
> The compat vDSO is a complicated hack that's needed to maintain
> compatibility with a small range of never-released glibc versions.
> 
> This removes it and replaces it with a much simpler hack: a config
> option to disable the 32-bit vDSO by default.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Can we verify this works correctly on the affected distributions?

	-hpa


