Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3H3XBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:01:11 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34265 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3H3XBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:01:08 -0400
Message-ID: <52212435.2040808@cogentembedded.com>
Date: Sat, 31 Aug 2013 03:01:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        netdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Drop support for Renesys H8/300 (h8300) architecture
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net> <1377880842-6835-2-git-send-email-linux@roeck-us.net>
In-Reply-To: <1377880842-6835-2-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/30/2013 08:40 PM, Guenter Roeck wrote:

    Subject typo: it's Renesas, not Renesys, according to the MAINTAINERS entry.

> H8/300 has been dead for several years, and the kernel for it
> has not compiled for ages. Drop support for it.

> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

WBR, Sergei

