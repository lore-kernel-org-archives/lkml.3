Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab3FMCjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:39:18 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41230 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3FMCjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <51B93038.9010202@huawei.com>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
	<1371070996-20613-5-git-send-email-tj@kernel.org>
	<51B93038.9010202@huawei.com>
Date: Wed, 12 Jun 2013 19:39:16 -0700
X-Google-Sender-Auth: AFgN4mWeAVbgF2-NPIcvt526Tik
Message-ID: <CAOS58YOFHpgFXh2jCZHg-pdu0x_2NNUohahcJJi5YmeR6H+zHA@mail.gmail.com>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, Cgroups <cgroups@vger.kernel.org>,
        Kent Overstreet <koverstreet@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 12, 2013 at 7:36 PM, Li Zefan <lizefan@huawei.com> wrote:
> Do you mean we prefer list_del_init() than list_del() in general? Then

Yes.

> in which cases do we prefer list_del()?

Nowadays, I don't think we ever prefer list_del(). Maybe if it can be
shown that the extra init part is noticeably expensive?

--
tejun
