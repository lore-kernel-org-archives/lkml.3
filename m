Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3JGX43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:56:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3JGX41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:56:27 -0400
Date: Mon, 7 Oct 2013 16:56:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Add check for sscanf without return use
Message-Id: <20131007165626.be437f74a4ba39e2be21af55@linux-foundation.org>
In-Reply-To: <1381189523.2081.225.camel@joe-AO722>
References: <1381189523.2081.225.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Oct 2013 16:45:23 -0700 Joe Perches <joe@perches.com> wrote:

> Naked use sscanf can be troublesome.

It would be helpful to expand on "troublesome"?

> Add a warning when the sscanf return value is not used.

Maybe it should be __must_check?


