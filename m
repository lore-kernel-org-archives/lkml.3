Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbaDHQzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:55:18 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62706 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaDHQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:55:14 -0400
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 11:55:12 -0500
Message-ID: <CANXECd79aK39SB=gKQ4Cbvi-B_FNh7oB+uv9Th6FQKx0hWZrkQ@mail.gmail.com>
Subject: Modules.Symvers - What is (not) and how to use it?
From: =?UTF-8?Q?Ismael_Farf=C3=A1n?= <sulfurfff@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys

I work on 3 modules, let's say:
KServervices, mod1, mod2

KServices exports functions consumed by mod1 and mod2.

Accidentally I was deleting Modules.Symvers after compiling KServices
and mod1 and mod2 failed to load because thery where looking for the
functions in a different offset than the one shown in /proc/kallsyms


QUESTION:
What is and how do I use that file?


I was hopping to find some good documentation in tldp.org, but
nothing, I only find forums that mention it, but nothing that can help
me understand it and probably find a way to stop requiring it.

Regards
Farfan



-- 
Do not let me induce you to satisfy my curiosity, from an expectation,
that I shall gratify yours. What I may judge proper to conceal, does
not concern myself alone.
