Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaA0KkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:40:04 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:33507 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaA0KkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:40:02 -0500
Message-ID: <52E63779.5090101@gmail.com>
Date: Mon, 27 Jan 2014 18:39:53 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, linux-kernel@vger.kernel.org,
        zhuyj <zyjzyj2000@gmail.com>
Subject: How to identify 6to4 and 6in4 tunnels
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Maintainers

In our scene, we will create the 6in4/6to4 tunnel firstly and need to 
check the tunnel type, secondly, we will configure the ip address on it. 
So, Could we have any way to get the actual tunnel for 6in4 and 6to4 
from current linux version?

Both 6in4 and 6to4 have the same protocol “IPPROTO_IPV6” in Linux 
kernel. The only difference is the ip address on the tunnel. Can we 
distinguish them in Linux kernel?

Best Regards

Zhu Yanjun
