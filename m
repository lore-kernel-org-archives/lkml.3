Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaDRNFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:05:25 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57555 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaDRNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CyFaP2phreKYdwUUB0RcpAhomDzm1QhAjCYtH09yYfQQ@mail.gmail.com>
References: <53511079.2020206@meduna.org>
	<CAOMZO5CyFaP2phreKYdwUUB0RcpAhomDzm1QhAjCYtH09yYfQQ@mail.gmail.com>
Date: Fri, 18 Apr 2014 10:05:11 -0300
Message-ID: <CAOMZO5DAixbrO1Zhvm60gevdCbKVgSP652vS7QYZS+XSfbPLdQ@mail.gmail.com>
Subject: Re: Freescale FEC i.MX28 restart problem
From: Fabio Estevam <festevam@gmail.com>
To: Stanislav Meduna <stano@meduna.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Jim Baxter <jim_baxter@mentor.com>,
        Duan Fugang-B38611 <B38611@freescale.com>,
        Frank Li <Frank.Li@freescale.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 9:59 AM, Fabio Estevam <festevam@gmail.com> wrote:

> Could you try the latest Russell's FEC patches available at?
> http://ftp.arm.linux.org.uk/cgit/linux-arm.git/log/?h=fec-testing

In particular this one could help with your "MDIO timeout" issue:
http://ftp.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=fec-testing&id=ec1fac3de70b16c69d3edc9f223e91d56b1915de
