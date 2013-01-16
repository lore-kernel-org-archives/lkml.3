Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3APQne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:43:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496Ab3APQn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:43:29 -0500
Date: Wed, 16 Jan 2013 17:00:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/3] signalfd: a kernel interface for dumping/restoring
	pending signals (v3)
Message-ID: <20130116160037.GA1167@redhat.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358182435-19245-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Andrey Vagin wrote:
>
> v3: minor cleanups

I have no more comments ;)

Obviously I can't ack this series, especially the API.

But correctness-wise everything looks fine to me, so

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

