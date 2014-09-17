Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaIQC3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:29:40 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:33804 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaIQC3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <1410920735-5767-2-git-send-email-laijs@cn.fujitsu.com>
References: <1410920735-5767-2-git-send-email-laijs@cn.fujitsu.com>
Date: Tue, 16 Sep 2014 19:29:38 -0700
Message-ID: <CANN689EUOraS_OLb1UqdgRzh-Jp+a+ZCx=SaSrvw4PAWyyfehg@mail.gmail.com>
Subject: Re: [PATCH] rbtree: add comment to rb_insert_augmented()
From: Michel Lespinasse <walken@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 7:25 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> The comment is copied from Documentation/rbtree.txt, but this comment
> is so important that it should also be in the code.
>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Michel Lespinasse <walken@google.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Looks good, thanks for proposing this.

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
