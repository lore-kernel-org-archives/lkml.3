Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3HEJqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:46:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3HEJqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:46:37 -0400
Date: Mon, 5 Aug 2013 11:45:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: Misc perf stat improvements
Message-ID: <20130805094559.GD18719@krava.redhat.com>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 05:41:08PM -0700, Andi Kleen wrote:
> Here are a couple of perf stat improvements/cleanups:
> 
> - output more information (ratios) in CSV mode
> - add --initial-delay to skip startup phase of program
> - handle pipes better in interval mode
> - some cleanup
> 

for the patchset:

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
