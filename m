Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3F2GfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 02:35:11 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34002 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3F2GfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 02:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <51CD9A62.3020404@zytor.com>
References: <1372420245-60021-1-git-send-email-wedsonaf@gmail.com>
	<51CD9A62.3020404@zytor.com>
Date: Fri, 28 Jun 2013 23:35:08 -0700
Message-ID: <CANeycqoRbiVaijeegeOLRh3sqENUL8yQakYMexBGM-H93+gz-w@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Use asm-goto to implement mutex fast path on x86-64
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 7:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> As Ingo said, looks very nice.  However, it is really too late for Linux
> 3.11, so I'm going to put it on a queue I already have for 3.12.

That's fine, I'm not in a hurry. Thanks.
