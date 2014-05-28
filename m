Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaE1A2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:28:04 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54644 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaE1A2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:28:01 -0400
Date: Wed, 28 May 2014 02:28:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v3
Message-ID: <20140528002800.GH25366@two.firstfloor.org>
References: <1397673678-27452-1-git-send-email-andi@firstfloor.org>
 <20140526172746.GB2763@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526172746.GB2763@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> google says this pragma got obsolete.. any reason for using this?

google is wrong.

It's standard e.g. on MacOS and imho simpler and nicer than 
the usual ifdef. But I removed it.

-Andi
