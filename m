Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab3IHVRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 17:17:05 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57639 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IHVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 17:17:03 -0400
Message-ID: <522CE948.5050800@gmail.com>
Date: Sun, 08 Sep 2013 14:16:56 -0700
From: mark zhu <mhz.dybf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130809 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Using sendfile() between sockets
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Two splice() system calls are needed for splicing 2 sockets.
It is costly with respect to context switching. What would be
the reason for_not_  letting sendfile() support socket-to-socket
splicing if the offset argument is ignored?

Thanks,
-Mark

