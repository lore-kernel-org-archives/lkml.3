Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781AbaGYUM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:12:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50350 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaGYUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:12:57 -0400
Message-ID: <53D2BA45.8030502@amacapital.net>
Date: Fri, 25 Jul 2014 13:12:53 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sergey Oboguev <oboguev.public@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
In-Reply-To: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:45 PM, Sergey Oboguev wrote:
> [This is a repost of the message from few day ago, with patch file
> inline instead of being pointed by the URL.]
> 
> This patch is intended to improve the support for fine-grain parallel
> applications that may sometimes need to change the priority of their threads at
> a very high rate, hundreds or even thousands of times per scheduling timeslice.

What is the authlist stuff for?  It looks complicated and it seems like
it should be unnecessary.

What's with the save/restore code?  What's it saving and restoring?

--Andy
