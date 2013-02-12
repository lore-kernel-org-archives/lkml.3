Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab3BLX5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:57:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3BLX47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:56:59 -0500
Date: Tue, 12 Feb 2013 15:56:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Add a simple doc for selftests
Message-Id: <20130212155657.86443c7c.akpm@linux-foundation.org>
In-Reply-To: <1360317764.684151.590003024082.1.gpush@pecola>
References: <20130207151333.f01d415c.akpm@linux-foundation.org>
	<1360317764.684151.590003024082.1.gpush@pecola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2013 18:02:44 +0800
Jeremy Kerr <jk@ozlabs.org> wrote:

> On 08/02/13 07:13, Andrew Morton wrote:
> 
> > The general ruleset for selftests is: do as much as you can if you're not
> > root and don't take too long and don't break the build on any
> > architecture and don't cause the top-level "make run_tests" to fail if
> > your feature is unconfigured.
> 
> This change adds a little documentation to the tests under
> tools/testing/selftests/, based on akpm's explanation.

Looks nice, thanks ;)

I'm thinking we move it from Documentation/selftests.txt to
tools/testing/selftests/README.txt, where people are more likely to
notice it?


