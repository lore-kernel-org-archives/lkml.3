Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaHDPph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:45:37 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46158 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaHDPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:45:35 -0400
Date: Mon, 4 Aug 2014 08:45:32 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] bridge: remove a useless comment
Message-ID: <20140804084532.6b84524c@haswell.linuxnetplumber.net>
In-Reply-To: <1407158554-17384-1-git-send-email-mst@redhat.com>
References: <1407158554-17384-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014 15:22:40 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> commit 6cbdceeb1cb12c7d620161925a8c3e81daadb2e4
>     bridge: Dump vlan information from a bridge port
> introduced a comment in an attempt to explain the
> code logic. The comment is unfinished so it confuses more
> than it explains, remove it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>

