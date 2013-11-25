Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3KYKEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3KYKEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:04:10 -0500
Date: Mon, 25 Nov 2013 11:03:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 04/22] tools lib traceevent: Add jbd2 plugin
Message-ID: <20131125100344.GD3161@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-5-git-send-email-jolsa@redhat.com>
 <1385130477.1747.33.camel@leonhard>
 <20131123035221.73f67ab7@gandalf.local.home>
 <20131125094618.GC3161@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125094618.GC3161@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:46:18AM +0100, Jiri Olsa wrote:
> > > Shouldn't it unregister these functions when unloaded?
> > 
> > Probably ;-)
> 
> will add,

hum... haven't found exported interface to unregister/remove
for print function, seems like this is getting freed in the
end at:

  void pevent_free(struct pevent *pevent)

jirka
