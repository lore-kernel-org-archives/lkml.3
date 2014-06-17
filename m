Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaFQLhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:37:16 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:58547 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaFQLhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:37:15 -0400
MIME-Version: 1.0
X-Originating-IP: [80.246.32.33]
In-Reply-To: <1402952842-12886-1-git-send-email-mina86@mina86.com>
References: <1402952842-12886-1-git-send-email-mina86@mina86.com>
Date: Tue, 17 Jun 2014 13:37:13 +0200
Message-ID: <CAPh34mfF60+yB2O03WYM0D6QitZzjnQUF86irG8o42b0TeJYCA@mail.gmail.com>
Subject: Re: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using min
 and max
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, back in the days where I submitted the patch I saw improvement in
the generated code (focus on number of instructions). Don't know what
happends with gcc in the meantime. Anyway, patch and analysis looks
good. So from a clean-patch perspective you get an:

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
