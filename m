Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3DKSkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:40:10 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38289 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3DKSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <1365559613.2183.7.camel@rzhang1-mobl4>
References: <1365544758-15245-1-git-send-email-abrestic@chromium.org>
	<1365559613.2183.7.camel@rzhang1-mobl4>
Date: Thu, 11 Apr 2013 11:40:04 -0700
X-Google-Sender-Auth: oOU79z4xSfYghvWzgniZK4GllUg
Message-ID: <CAL1qeaEjmtwTZ4QRaDyD9Mb5Rko39uSN6NrjwyOT7_43NaH+Vw@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos: fix handling of invalid frequency table entries
From: Andrew Bresticker <abrestic@chromium.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> can you please verify
> commit  fc35b35cbe24ef021ea9acfba21e54da958df747
> commit 57df8106932b57427df1eaaa13871857f75b1194
> at
> http://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/log/?h=thermal
> fixes the problem for you?

It does.  Thanks!

-Andrew
