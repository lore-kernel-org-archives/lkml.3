Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbaGSJCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:02:52 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33776 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbaGSJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140708073712.GC25880@mwanda>
References: <CANeU7Q=a82YmUE49uZ1sOxZn0KGLuktSXuj7YsmUb=wXQEpPXA@mail.gmail.com>
	<20140708073712.GC25880@mwanda>
Date: Sat, 19 Jul 2014 02:02:49 -0700
X-Google-Sender-Auth: LIQ1q4gYsMj16DucL1LV3W9kV2c
Message-ID: <CANeU7Q=YfKEi8WBhNoUQOXpG_6jV1KMUsq=N-rVo1maaNERyAA@mail.gmail.com>
Subject: Re: [PATCH] sparse: Add CLOG option for saving warning
From: Christopher Li <sparse@chrisli.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 12:37 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> My kernel tree is full of drivers/foo.c.smatch and
> drivers/foo.c.smatch-info files...
>
> It would be nice to add it to .gitignore as well.

Actually, ".*" is already in the .gitignore, there for the sparse log files
are covered.

Chris
