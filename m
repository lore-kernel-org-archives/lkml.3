Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3KDWV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:21:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3KDWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:21:27 -0500
Date: Mon, 4 Nov 2013 14:21:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] checkpatch: Improve "return is not a function" test
Message-Id: <20131104142125.9bdb91fae696a802ee0d6b3b@linux-foundation.org>
In-Reply-To: <1383261164.2769.6.camel@joe-AO722>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
	<1383070766.12439.13.camel@joe-AO722>
	<526FFED4.4070902@linux.intel.com>
	<1383071755.12439.17.camel@joe-AO722>
	<52700D4C.10008@linux.intel.com>
	<1383075490.12439.26.camel@joe-AO722>
	<1383261164.2769.6.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 16:12:44 -0700 Joe Perches <joe@perches.com> wrote:

> This now uses the "$balanced_parens" test and also makes
> the test depend on perl v5.10 and higher.

What happens if one uses an older perl version?  A mysterious-looking
splat, I assume?

It would be nicer to have some explicit perl version test which tells
user what the problem is, and which perl version is needed?

