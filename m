Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3BPHow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 02:44:52 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45003 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3BPHov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 02:44:51 -0500
MIME-Version: 1.0
In-Reply-To: <511F0775.6030008@asianux.com>
References: <511F0775.6030008@asianux.com>
Date: Fri, 15 Feb 2013 23:44:51 -0800
X-Google-Sender-Auth: oeqtHLNfWClTj-5KN2mrkyvEFec
Message-ID: <CAGXu5jKKcG8qjRCjpfWC1Crj48PBTg-LV0czmM4+pFieE3dr9Q@mail.gmail.com>
Subject: Re: [PATCH v2] kernel: arg2 is unsigned long which is never < 0
From: Kees Cook <keescook@chromium.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 8:13 PM, Chen Gang <gang.chen@asianux.com> wrote:
>
>   arg2 will never < 0, for its type is 'unsigned long'
>
>   so need beautify the relative source code (better to use macros).
>
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
