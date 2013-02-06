Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3BFVhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:37:16 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:61779 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3BFVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:37:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130206112811.GD8696@gmail.com>
References: <1360069915-31619-1-git-send-email-alex.shi@intel.com>
 <20130205145854.GA30949@gmail.com> <51119ED0.3030207@intel.com> <20130206112811.GD8696@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Feb 2013 08:36:50 +1100
X-Google-Sender-Auth: tDJFopnVakkDlmkYe6AXW97Q9XY
Message-ID: <CA+55aFwFCXGE9zTOOqGzC5wBDk+KjBZvqDpiiFYcVSsbv0ThPQ@mail.gmail.com>
Subject: Re: [PATCH] rwsem: steal writing sem for better performance
To: Ingo Molnar <mingo@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Linus, Andrew, what is your thinking about the patch and about
> the timing of the patch?

Not for 3.8. Queue it for 3.9, with possibly a stable tag with a big
comment "apply after much testing".

              Linus
