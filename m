Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FZQQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:16:15 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62294 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3FZQQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:16:14 -0400
MIME-Version: 1.0
In-Reply-To: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com>
References: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com>
Date: Wed, 26 Jun 2013 18:16:13 +0200
Message-ID: <CADDKRnCP_s2hL2wr8TsKeToNRt5nXF3NBYAqkmCCUPX8HbY_yQ@mail.gmail.com>
Subject: Re: [v3.10-rc2] iwlwifi regression
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/25 Jörg Otte <jrg.otte@gmail.com>:
> If iwlwifi/iwldvm are built into the kernel (no loadable modules)
> following error is written to console and syslog since v3.10-rc:
>
> iwlwifi 0000:08:00.0: failed to load module iwldvm (error -38), is
> dynamic loading enabled?
>
> reverting
> commit 1618b2b02a3a0ee7a6863fed4b0d22e697e7e97c
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Apr 4 10:35:23 2013 +0200
>     iwlwifi: print warning on request_module failure
>
> fixes the problem for me.
>
> Jörg
>
> I'm not subscribed,please CC me in answeres

We have rc-7 now and it's still not fixed. What is the problem?

Thanks, Jörg
