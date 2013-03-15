Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3COSMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:12:37 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59992 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3COSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <1363366923-6269-1-git-send-email-nschichan@freebox.fr>
References: <1363366923-6269-1-git-send-email-nschichan@freebox.fr>
Date: Fri, 15 Mar 2013 11:12:35 -0700
X-Google-Sender-Auth: _GFEm8o7NIynR2qsd0f-MBbRQDo
Message-ID: <CAGXu5j+3XSbxUBHvZqXUKseqxTS+YG-1E4h1_dpKfUnM8O+ctw@mail.gmail.com>
Subject: Re: [PATCH] seccomp: allow BPF_XOR based ALU instructions.
From: Kees Cook <keescook@chromium.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:02 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:
>
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>

Ah, good catch. Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
