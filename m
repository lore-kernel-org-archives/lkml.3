Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3BOW6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:58:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3BOW6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:58:41 -0500
Date: Fri, 15 Feb 2013 14:58:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        davej@redhat.com, keescook@chromium.org, stable@vger.kernel.org,
        tglx@linutronix.de, gorcunov@openvz.org, ebiederm@xmission.com
Subject: Re: + futex-avoid-kernel-taint-caused-by-get_robust_list.patch
 added to -mm tree
Message-Id: <20130215145839.6cebfcb2.akpm@linux-foundation.org>
In-Reply-To: <20130215234444.29345fc3@spider.haslach.nod.at>
References: <20130215222653.B8B115A41F0@corp2gmr1-2.hot.corp.google.com>
	<20130215234444.29345fc3@spider.haslach.nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 23:44:44 +0100
Richard Weinberger <richard@nod.at> wrote:

> As stated in [0], I'd simply revert commit ec0c4274 ("futex: Mark
> get_robust_list as deprecated")

Too much talk, not enough patches.  I typed it all in again.
