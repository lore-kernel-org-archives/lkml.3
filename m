Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3GKTwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:52:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28650 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3GKTwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:52:31 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nbHVgzOhg_YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QEdfzldPcAgA:10 a=vzBVADr1y56fVXvKGAwA:9 a=QEXdDO2ut3YA:10 a=e7U0Ab5NiPAA:10 a=1SMnlZjMYawA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373572348.17876.59.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>
Date: Thu, 11 Jul 2013 15:52:28 -0400
In-Reply-To: <alpine.LNX.2.00.1307112141151.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	  <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
	  <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
	 <1373558223.17876.22.camel@gandalf.local.home>
	 <alpine.LNX.2.00.1307112141151.29788@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 21:43 +0200, Jiri Kosina wrote:

> OTOH we apparently don't need the one after the text_poke() below, as 
> syncing the cores just after patching the first byte afterwards provides 
> safe enough guard (at least according to hpa's words back in 2010 :) ).

Right, but I'm paranoid enough to keep it anyway ;-)

-- Steve


