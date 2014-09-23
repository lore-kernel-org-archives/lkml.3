Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaIWNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:04:17 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:46414 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaIWNEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:04:12 -0400
Message-ID: <54216FC9.5060605@gmail.com>
Date: Tue, 23 Sep 2014 09:04:09 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: linux@arm.linux.org.uk
CC: will.deacon@arm.com, lauraa@codeaurora.org, steve.capper@arm.com,
        steve.capper@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: FIX Me in pgtable.h
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Arm Maintainers,
I am wondering about the fix me in pgtable.h for define kern_addr_valid and how to set it to a correct
value as you state that this needs to be fixed as the defined macro is still 1. This is probably incorrect
and should be changed.
Thanks,
Nick 
