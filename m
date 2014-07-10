Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaGJAGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:06:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40354 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaGJAGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:06:30 -0400
Date: Thu, 10 Jul 2014 02:06:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files v3
Message-ID: <20140710000629.GQ18735@two.firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-4-git-send-email-andi@firstfloor.org>
 <20140709222007.GI20938@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709222007.GI20938@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> what happens if we fail to realloc?

Then the field doesn't get added. No problem.

-Andi
