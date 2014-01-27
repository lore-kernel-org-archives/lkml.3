Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaA0M7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:59:09 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50792 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0M7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:59:07 -0500
Message-ID: <52E65817.1090904@6wind.com>
Date: Mon, 27 Jan 2014 13:59:03 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: zhuyj <zyjzyj2000@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: How to identify 6to4 and 6in4 tunnels
References: <52E63779.5090101@gmail.com>
In-Reply-To: <52E63779.5090101@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/01/2014 11:39, zhuyj a écrit :
> Hi, Maintainers
>
> In our scene, we will create the 6in4/6to4 tunnel firstly and need to check the
> tunnel type, secondly, we will configure the ip address on it. So, Could we have
> any way to get the actual tunnel for 6in4 and 6to4 from current linux version?
>
> Both 6in4 and 6to4 have the same protocol “IPPROTO_IPV6” in Linux kernel. The
> only difference is the ip address on the tunnel. Can we distinguish them in
> Linux kernel?
Just check the prefix, like it is done in check_6rd().


Regards,
Nicolas
