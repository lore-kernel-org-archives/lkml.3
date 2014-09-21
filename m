Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaIUH5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 03:57:21 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48241 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaIUH5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 03:57:20 -0400
Message-ID: <541E84E8.8050709@gmail.com>
Date: Sun, 21 Sep 2014 15:57:28 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Consult] About using 'compiler.h' in uapi header files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all:

I find many "include/uapi/linux/*.h" need "include/linux/compiler.h",
is it still OK?? (in my memory, only the headers in "uapi" are for
outside using).

For me, we need move 'compiler.h' to "include/uapi/linux/".

Welcome any ideas, suggestions, or completions.

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
