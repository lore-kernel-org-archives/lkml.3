Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3BGBik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:38:40 -0500
Received: from intranet.asianux.com ([58.214.24.6]:58109 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3BGBii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:38:38 -0500
X-Spam-Score: -100.8
Message-ID: <51130593.30801@asianux.com>
Date: Thu, 07 Feb 2013 09:38:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] kernel: arg2 is unsigned long which is never < 0
References: <511217F3.6050800@asianux.com> <20130206085653.GQ1712@moon> <51123236.3060001@asianux.com> <CAGXu5jJ7AY93Qn0BuECBJprxV2MH1-DV7qMfwEQ9J0UP-cHMqw@mail.gmail.com>
In-Reply-To: <CAGXu5jJ7AY93Qn0BuECBJprxV2MH1-DV7qMfwEQ9J0UP-cHMqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月07日 03:41, Kees Cook 写道:
> Well, it seems we'd need to add an include to gain access to binfmts.h
> in once place, but that doesn't seem bad. I'll send to patch to clean
> this up.

  thank you.

  and after your patch is integrated into main branch (at least in
next-* branch), I should send patch v2 for it, too.

  and excuse me I will 'disappear' during next 7-10 days for Chinese
Year (Spring Festival).

  during these days, welcome any members to send patch v2 instead of me
(better to mark Reported-by Cyrill Gorcunov <gorcunov@openvz.org>, too)

  thanks.

  :-)

-- 
Chen Gang

Asianux Corporation
