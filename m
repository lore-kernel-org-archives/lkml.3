Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936645Ab3DHPwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936624Ab3DHPwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:52:08 -0400
Date: Mon, 8 Apr 2013 17:51:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Peter Zijlstra <peterz@infradead.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [RFC/PATCH] perf: Expand definition of sysfs format attribute
Message-ID: <20130408155156.GB1287@krava.redhat.com>
References: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
 <1365411915.2609.143.camel@laptop>
 <20130408115749.GB17849@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408115749.GB17849@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 09:57:50PM +1000, Michael Ellerman wrote:

SNIP

> > 
> > ISTR discussing this with Jiri at some point.. I think we ended up with
> > being fine with overlapping ranges but having perf issue a warning (not
> > an error) when attributes of a single event have overlap.
> 
> OK great.
> 
> > I'm not sure the latter was ever implemented in the userspace side.
> 
> Yeah not that I can see with a quick look. It's fairly advanced usage
> IMHO so a warning would be nice, but not essential.

oops, missed this email.. sry

it should be ok to overlap.. we don't check those ranges in perf
tool now.. just take whatever is defined in format file

adding the warning to my todo list ;-)

jirka
