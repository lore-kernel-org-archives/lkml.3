Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaDBAjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:39:25 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50641 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327AbaDBAjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <1396391358-22367-1-git-send-email-mdempsky@chromium.org>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
 <1396391358-22367-1-git-send-email-mdempsky@chromium.org>
From: Matthew Dempsky <mdempsky@chromium.org>
Date: Tue, 1 Apr 2014 17:39:00 -0700
X-Google-Sender-Auth: bSsefF5G8QmGBcMKSN_evHGNWUE
Message-ID: <CAF52+S7u8gRjce3vxu9SZTRXXP=nBx7BnHeC3BwuL_e7+tnE-g@mail.gmail.com>
Subject: Re: [PATCH v3] ptrace: Fix fork event messages across pid namespaces
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Dempsky <mdempsky@chromium.org>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 3:29 PM, Matthew Dempsky <mdempsky@chromium.org> wrote:
> Revised patch below.  Unfortunately, I just realized I don't have my
> test machine handy, so I won't be able to test it until tomorrow.

Quick update: Julien helped me setup a VM to test this, and the patch
still passes my test case without any obvious issues.
