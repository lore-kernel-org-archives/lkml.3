Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaFEWQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:16:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaFEWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:16:34 -0400
Date: Thu, 5 Jun 2014 15:16:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: eric.ernst@linux.intel.com
Cc: rdunlap@infradead.org, jwboyer@fedoraproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Add kernel parameter for kernel version
Message-Id: <20140605151633.7dd15e8307cbd3b519ae257b@linux-foundation.org>
In-Reply-To: <1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com>
References: <538CC567.2060305@linux.intel.com>
	<1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Jun 2014 15:09:17 -0700 eric.ernst@linux.intel.com wrote:

> Create a kernel cmdline parameter, "version_addendum", which can be
> used to add text to the kernel version that is reported from
> /proc/version.

why?
