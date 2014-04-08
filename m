Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbaDHVhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:37:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52726 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbaDHVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:37:38 -0400
Message-ID: <53446C20.1040409@infradead.org>
Date: Tue, 08 Apr 2014 14:37:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?SXNtYWVsIEZhcmbDoW4=?= <sulfurfff@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Modules.Symvers - What is (not) and how to use it?
References: <CANXECd79aK39SB=gKQ4Cbvi-B_FNh7oB+uv9Th6FQKx0hWZrkQ@mail.gmail.com>
In-Reply-To: <CANXECd79aK39SB=gKQ4Cbvi-B_FNh7oB+uv9Th6FQKx0hWZrkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 09:55 AM, Ismael Farfán wrote:
> Hello guys
> 
> I work on 3 modules, let's say:
> KServervices, mod1, mod2
> 
> KServices exports functions consumed by mod1 and mod2.
> 
> Accidentally I was deleting Modules.Symvers after compiling KServices
> and mod1 and mod2 failed to load because thery where looking for the
> functions in a different offset than the one shown in /proc/kallsyms
> 
> 
> QUESTION:
> What is and how do I use that file?
> 
> 
> I was hopping to find some good documentation in tldp.org, but
> nothing, I only find forums that mention it, but nothing that can help
> me understand it and probably find a way to stop requiring it.

There is a small bit of documentation for it in
kernel tree:Documentation/kbuild/modules.txt.


-- 
~Randy
