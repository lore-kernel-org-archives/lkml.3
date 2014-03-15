Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaCOC1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 22:27:11 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaCOC1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 22:27:09 -0400
Date: Sat, 15 Mar 2014 03:27:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/10] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140315022707.GB22728@two.firstfloor.org>
References: <1394832698-322-1-git-send-email-andi@firstfloor.org>
 <1394832698-322-2-git-send-email-andi@firstfloor.org>
 <5323859B.70201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5323859B.70201@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 04:41:31PM -0600, David Ahern wrote:
> On 3/14/14, 3:31 PM, Andi Kleen wrote:
> >@@ -374,6 +376,8 @@ LIB_OBJS += $(OUTPUT)util/stat.o
> >  LIB_OBJS += $(OUTPUT)util/record.o
> >  LIB_OBJS += $(OUTPUT)util/srcline.o
> >  LIB_OBJS += $(OUTPUT)util/data.o
> >+LIB_OBJS += $(OUTPUT)util/jsmn.o
> >+LIB_OBJS += $(OUTPUT)util/json.o
> >
> >  LIB_OBJS += $(OUTPUT)ui/setup.o
> >  LIB_OBJS += $(OUTPUT)ui/helpline.o
> >
> 
> CONFIG driven? Allow a user to omit this.

Why? It has no external dependencies. AFAIK that's the only reason for configs.

(unless you count the commands used by the shell script, but the basic parser
works fine even without the script)

-Andi
