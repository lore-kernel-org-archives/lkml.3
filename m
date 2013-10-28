Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab3J1PYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:24:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63871 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3J1PYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:24:13 -0400
Date: Mon, 28 Oct 2013 08:24:07 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/3] vxlan: silence one build warning
Message-ID: <20131028082407.03633f6b@nehalam.linuxnetplumber.net>
In-Reply-To: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
References: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 14:01:48 +0800
Zhi Yong Wu <zwu.kernel@gmail.com> wrote:

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> drivers/net/vxlan.c: In function ‘vxlan_sock_add’:
> drivers/net/vxlan.c:2298:11: warning: ‘sock’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> drivers/net/vxlan.c:2275:17: note: ‘sock’ was declared here
>   LD      drivers/net/built-in.o
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

This is much better.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
