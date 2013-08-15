Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3HOODB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:03:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55432 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3HOODA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:03:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520CDF92.8090804@roeck-us.net>
Date: Thu, 15 Aug 2013 07:02:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: tony@bakeyournoodle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
References: <520C9A39.3030808@roeck-us.net> <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
In-Reply-To: <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 02:46 AM, Max Filippov wrote:
> Hi Guenter,
>
> On Thu, Aug 15, 2013 at 1:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> Also, the xtensa compiler fails for me with an odd error message on one of
>> my servers.
>
> What is the message?
>
It complains about being unable to change the byte order in an object file.

Actually, the message is from the linker, but I have no idea what is causing it.
It works on two servers but fails on the third. At least in theory the installation
on all servers should be the same.

Guenter

