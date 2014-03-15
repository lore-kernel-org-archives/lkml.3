Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaCONEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 09:04:25 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:57631 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaCONEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 09:04:23 -0400
Date: Sat, 15 Mar 2014 10:04:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/10] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140315130417.GD14945@ghostprotocols.net>
References: <1394832698-322-1-git-send-email-andi@firstfloor.org>
 <1394832698-322-2-git-send-email-andi@firstfloor.org>
 <5323859B.70201@gmail.com>
 <20140315022707.GB22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140315022707.GB22728@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Mar 15, 2014 at 03:27:07AM +0100, Andi Kleen escreveu:
> On Fri, Mar 14, 2014 at 04:41:31PM -0600, David Ahern wrote:
> > On 3/14/14, 3:31 PM, Andi Kleen wrote:
> > >@@ -374,6 +376,8 @@ LIB_OBJS += $(OUTPUT)util/stat.o
> > >  LIB_OBJS += $(OUTPUT)util/record.o
> > >  LIB_OBJS += $(OUTPUT)util/srcline.o
> > >  LIB_OBJS += $(OUTPUT)util/data.o
> > >+LIB_OBJS += $(OUTPUT)util/jsmn.o
> > >+LIB_OBJS += $(OUTPUT)util/json.o

> > CONFIG driven? Allow a user to omit this.
 
> Why? It has no external dependencies. AFAIK that's the only reason for configs.
 
> (unless you count the commands used by the shell script, but the basic parser
> works fine even without the script)

Will this be useful for all arches?

- Arnaldo
