Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaIVK0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:26:36 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60933 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaIVK0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:26:35 -0400
Message-ID: <541FF958.7090905@gmail.com>
Date: Mon, 22 Sep 2014 06:26:32 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: rth@twiddle.net
CC: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Fix me in  bootpz.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings to Richard and the other maintainers of the alpha arch,
I am wondering what to do about the malloc area fix me message in bootpz.c
and how to fix this issue or is 2 MB the correct value to be defined for
malloc area as of now and I should just remove the fix me messages around 
the malloc define statment?
Regards,
Nick 
