Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaBLUzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:55:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45233 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbaBLUzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:55:03 -0500
Date: Wed, 12 Feb 2014 12:54:53 -0800
From: Kees Cook <kees@outflux.net>
To: Dave Jones <davej@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: flaw in "nf_tables: add reject module for NFPROTO_INET"
Message-ID: <20140212205453.GL23300@outflux.net>
References: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
 <20140212204307.GK23300@outflux.net>
 <20140212205037.GA6563@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212205037.GA6563@redhat.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 03:50:37PM -0500, Dave Jones wrote:
> On Wed, Feb 12, 2014 at 12:43:08PM -0800, Kees Cook wrote:
>  > Hi,
>  > 
>  > This seems like a legit problem detected by Coverity. Looks like a break is
>  > missing?
> 
> yup, reported this morning. 
> (Also note that I changed the state in coverity once Patrick confirmed it)

Ah, sorry for the noise then! I missed Dave's earlier the bug report email.

-Kees

-- 
Kees Cook                                            @outflux.net
