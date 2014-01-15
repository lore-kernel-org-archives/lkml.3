Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaAOAKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:10:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAOAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:09:59 -0500
Date: Tue, 14 Jan 2014 16:09:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: atomlin@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, oleg@redhat.com,
        riel@redhat.com
Subject: Re: [RFC PATCH v2 0/2] hung_task: Display every hung task warning
Message-Id: <20140114160957.949dc28b1d766598792c2ba8@linux-foundation.org>
In-Reply-To: <1389742918-32598-1-git-send-email-atomlin@redhat.com>
References: <1389742918-32598-1-git-send-email-atomlin@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 23:41:56 +0000 atomlin@redhat.com wrote:

> The khungtaskd thread limits how many hung task warnings it displays
> at a time, when a timeout occurs. This patch allows that limit to be
> set to "unlimited", by setting hung_task_warnings to -1, which will
> cause khungtaskd to display information about all hung tasks.

The changelog provides no reason why you think this change should be
made.  This is awkward, because it means that nobody has any reason
to apply the patch!

