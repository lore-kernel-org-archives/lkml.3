Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3HOJHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:07:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60890 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3HOJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:07:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520C9A39.3030808@roeck-us.net>
Date: Thu, 15 Aug 2013 02:07:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: tony@bakeyournoodle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Linux kernel cross-compilers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

would it be possible to provide an arm64 cross-compiler on https://www.kernel.org/pub/tools/crosstool/ ?
Also, the xtensa compiler fails for me with an odd error message on one of my servers.
Have you heard about any problems with it from others ?

c6x is supposed to be supported by gcc now. No idea if that helps anything, though.

Thanks,
Guenter
