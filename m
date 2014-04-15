Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaDOJqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:46:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaDOJq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:46:27 -0400
Date: Tue, 15 Apr 2014 11:40:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, acme@kernel.org, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] perf: Create hist_entry groups
Message-ID: <20140415094015.GB1700@krava.brq.redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
 <878ur7thwh.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ur7thwh.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:01:50PM +0900, Namhyung Kim wrote:
> Hi Don,
> 

SBIP

> 
> Another one I'd like to introduce is somewhat similar to your work.
> It's called hierarchy view and groups each entries according to sort
> keys [2].  But it only supported --gtk output at that time (in order not
> to make the hands dirty unnecessarily ;-) and (thus?) didn't get much
> review.  But I think the idea is same and requires less change by just
> adding few fields (rb_root) to hist_entry instead of new data structure.

hi,
I dont recall seeing that [2], but it's one year back ;-) it looks like
what Don is talking about, do you have it in branch?

thanks,
jirka
