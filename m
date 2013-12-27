Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3L0WiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:38:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3L0WiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:38:23 -0500
Date: Fri, 27 Dec 2013 14:38:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests : Adding symbolic link limits test script
Message-Id: <20131227143822.2b2a8bc448fb7e0800f05f53@linux-foundation.org>
In-Reply-To: <20131225172310.6eb4aa79f79a9fa5a79b3f4e@skynet.be>
References: <20131225172310.6eb4aa79f79a9fa5a79b3f4e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Dec 2013 17:23:10 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> This patch adds fs directory in selftests and a script to explain recursive
> and consecutive symbolic linking limits who have been debated
> so many times.

hm, it's a "test" which doesn't really test anything - it always
succeeds.

Why do you think the kernel needs this?
