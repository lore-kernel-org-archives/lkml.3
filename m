Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3HATIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:08:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62992 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3HATID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:08:03 -0400
Message-ID: <51FAB226.3040405@windriver.com>
Date: Thu, 1 Aug 2013 15:08:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Backports of jbd2 commits to jbd
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-01 03:01 PM, Paul Gortmaker wrote:
> The following commits exist in jbd2, and the backport to jbd is
> relatively straightforward.  In doing so we make the debug enable
> interface consistent between jbd and jbd2.
> 
> For testing, I've booted up a machine with ext3 fs, done some basic
> operations (update a git tree, build a kernel) and also ensured that
> enabling debug via the new /sys/module/jbd/parameters/ entry works.
> Testing was on a baseline of v3.10-rc1-39-g741ddbc.

That should have been v3.11-rc3-40-g75eaff0; the above just happens
to be the 1st non-merge commit on mainline today.
