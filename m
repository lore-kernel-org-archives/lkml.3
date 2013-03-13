Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab3CMXRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:17:47 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58128 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3CMXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:17:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130313231413.GA3265@jtriplet-mobl1>
References: <20130313231413.GA3265@jtriplet-mobl1>
Date: Wed, 13 Mar 2013 16:17:44 -0700
X-Google-Sender-Auth: hOmPE58znKfpZjW3mwhbxkdAEn8
Message-ID: <CAGXu5jJe-XG7jLcx4GCysXQujH2sUdgF-NuLVVeB5TWGUikhxg@mail.gmail.com>
Subject: Re: [PATCH] fs: Don't compile in drop_caches.c when CONFIG_SYSCTL=n
From: Kees Cook <keescook@chromium.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:14 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> drop_caches.c provides code only invokable via sysctl, so don't compile
> it in when CONFIG_SYSCTL=n.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Seems reasonable to me.

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
