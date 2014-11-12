Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaKLAgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:36:37 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60621 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaKLAgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:36:36 -0500
Date: Wed, 12 Nov 2014 01:36:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/8] perf, tools: Support source line numbers in
 annotate
Message-ID: <20141112003634.GN12538@two.firstfloor.org>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-6-git-send-email-andi@firstfloor.org>
 <20141020180605.GC9913@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020180605.GC9913@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and making the source line not to be shifted
> right by line number width would be great

That was intentional, so that if you have a 80 char terminal and the
source code is 80 characters no unnecessary space is wasted.

-Andi
