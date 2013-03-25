Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab3CYOyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:54:11 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:41232 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab3CYOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+3XSbxUBHvZqXUKseqxTS+YG-1E4h1_dpKfUnM8O+ctw@mail.gmail.com>
References: <1363366923-6269-1-git-send-email-nschichan@freebox.fr>
	<CAGXu5j+3XSbxUBHvZqXUKseqxTS+YG-1E4h1_dpKfUnM8O+ctw@mail.gmail.com>
Date: Mon, 25 Mar 2013 09:54:09 -0500
Message-ID: <CABqD9hbT4=10Dasq69d7i-2YZxjqH8ym1wKbfK-4XYWpj35uFg@mail.gmail.com>
Subject: Re: [PATCH] seccomp: allow BPF_XOR based ALU instructions.
From: Will Drewry <wad@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better late than never .. right?

Acked-by: Will Drewry <wad@chromium.org>

Thanks!

On Fri, Mar 15, 2013 at 1:12 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Mar 15, 2013 at 10:02 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:
>>
>> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
>
> Ah, good catch. Thanks!
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> --
> Kees Cook
> Chrome OS Security
