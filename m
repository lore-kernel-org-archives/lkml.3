Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3BGLjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:39:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64314 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3BGLjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:39:11 -0500
Message-ID: <51139246.6090709@mvista.com>
Date: Thu, 07 Feb 2013 15:38:46 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net, sebastian@breakpoint.cc
Subject: Re: [PATCH 1/1]linux-usb: fix the idProduct value to be compatible
 with current CPU in initializers.c
References: <fe8ad35c629c.629cfe8ad35c@huawei.com>
In-Reply-To: <fe8ad35c629c.629cfe8ad35c@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-02-2013 11:32, fangxiaozhi 00110321 wrote:

> From: fangxiaozhi <huananhu@huawei.com>

> 1. The idProduct is little endian, so make sure its value to be compatible with the current CPU. Make no break on big endian processors.

    Wrap your lines reasonable at 80 columns at last (better somewht less). 
And why "1." here? Where is "2."?

> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> --------------------------------------------------------------------

    Either use --- tearline, or no tearline at all.

WBR, Sergei

