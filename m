Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaGJGZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaGJGZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:50 -0400
Date: Thu, 10 Jul 2014 08:25:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files v3
Message-ID: <20140710062508.GA24705@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-4-git-send-email-andi@firstfloor.org>
 <20140709221958.GH20938@krava.redhat.com>
 <20140710000554.GP18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710000554.GP18735@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 02:05:54AM +0200, Andi Kleen wrote:
> On Thu, Jul 10, 2014 at 12:19:58AM +0200, Jiri Olsa wrote:
> > Im confused, your branch shows v4 in patch Subject,
> > while this patch has v3... ?
> 
> Patchkits and patches both have their own numeric 
> version spaces.

yes, but this specific patch has higher (different) version
in the branch, that patch you sent

jirka
