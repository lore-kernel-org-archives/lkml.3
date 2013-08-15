Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3HOJqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:46:19 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38193 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3HOJqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <520C9A39.3030808@roeck-us.net>
References: <520C9A39.3030808@roeck-us.net>
Date: Thu, 15 Aug 2013 13:46:16 +0400
Message-ID: <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
Subject: Re: Linux kernel cross-compilers
From: Max Filippov <jcmvbkbc@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: tony@bakeyournoodle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Thu, Aug 15, 2013 at 1:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Also, the xtensa compiler fails for me with an odd error message on one of
> my servers.

What is the message?

> Have you heard about any problems with it from others ?

Yes, xtensa compiler/linker is known to have issues with link-time
relaxation; e.g. it may fail to build linux image without CONFIG_LD_NO_RELAX.

-- 
Thanks.
-- Max
