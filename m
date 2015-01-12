Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbbALXKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:10:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbbALXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:10:05 -0500
Date: Mon, 12 Jan 2015 15:10:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v12 10/20] dax: Replace XIP documentation with DAX
 documentation
Message-Id: <20150112151004.2080339a518ee43da95a6176@linux-foundation.org>
In-Reply-To: <1414185652-28663-11-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-11-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:42 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> Based on the original XIP documentation, this documents the current
> state of affairs, and includes instructions on how users can enable DAX
> if their devices and kernel support it.

Nice ;)
