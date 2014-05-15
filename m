Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaEOVcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:32:09 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41626 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaEOVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:32:05 -0400
Date: Thu, 15 May 2014 14:32:02 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        davem@davemloft.net
Subject: Re: [PATCH] net: tunnels - enable module autoloading
Message-ID: <20140515143202.53ca8033@nehalam.linuxnetplumber.net>
In-Reply-To: <1399970908-9973-1-git-send-email-teg@jklm.no>
References: <1399970908-9973-1-git-send-email-teg@jklm.no>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 10:48:28 +0200
Tom Gundersen <teg@jklm.no> wrote:

> Enable the module alias hookup to allow tunnel modules to be autoloaded on demand.
> 
> This is in line with how most other netdev kinds work, and will allow userspace
> to create tunnels without having CAP_SYS_MODULE.
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Tested-by: Susant Sahani <susant@redhat.com>
> ---
>  net/ipv4/ipip.c       | 1 +
>  net/ipv6/ip6_tunnel.c | 1 +
>  net/ipv6/sit.c        | 1 +
>  3 files changed, 3 insertions(+)

But tunnel modules are autoloaded now.
If I create a tunnel with ip tunnel based on the existing MODULE_ALIAS_NETDEV().

