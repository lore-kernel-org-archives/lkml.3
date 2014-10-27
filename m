Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaJ0OmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:42:21 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40190 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaJ0OmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:42:18 -0400
Message-ID: <544E59C3.7010309@telliq.com>
Date: Mon, 27 Oct 2014 15:42:11 +0100
From: Jan Kardell <jan.kardell@telliq.com>
Organization: TelliQ AB
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>
CC: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: rtc: NXP pcf8563 vs Haoyu hym8563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Erlier this year the hym8563 driver was added to the kernel. When I compared
the datasheets of the NXP pcf8563 (that I use) and the Haoyu hym8563 I 
cannot
find any significantdifferences between the two chips. Now is using 
different
drivers for the two similar (or identical?) chips:
a) A mistake
b) A feature
c) Me beeing stupid?

The difference between the drivers is handling of century and that the 
hym8563
driver support the clock output that both chips have.

//Jan
