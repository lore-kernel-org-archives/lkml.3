Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaIVNqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaIVNqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:46:23 -0400
Date: Mon, 22 Sep 2014 15:46:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: taeung <treeze.taeung@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, acme@kernel.org
Subject: Re: [PATCH] modified error code when perf_session__new() fail
Message-ID: <20140922134616.GC18187@krava.brq.redhat.com>
References: <541946D8.1080209@gmail.com>
 <1411227895.1690.23.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411227895.1690.23.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 12:44:55AM +0900, Namhyung Kim wrote:
> Hi Taeung,
> 
> Please CC perf maintainers when you send a perf patch.  I'm adding
> Arnaldo who maintains tooling part and Jiri who suggested this change.
> 
> 
> 2014-09-17 (수), 17:31 +0900, taeung:
> > Hi,
> > 
> > I modified error code for the requirement as below.
> > 
> > Author: taeung <treeze.taeung@gmail.com>
> > Date:   Sat Sep 13 16:22:53 2014 +0900
> > 
> >       modified error code when perf_session__new() fail
> > 
> >          Because perf_session__new() could fail
> >          for more reasons than just ENOMEM,
> >          I modified error code(ENOMEM or EINVAL)
> >          into -1.
> 
> Hmm.. this seems you copied output of "git show" and send it via an
> email client.  I recommend you to use "git format-patch" and "git
> send-email" later.

yep, the patch is mangled.. also following doc might be useful:
Documentation/email-clients.txt

> 
> In addition, you forgot to add your Signed-off-by.
> 
> That being said I'm okay with the patch itself.  Jiri, this is what you
> wanted to do, right?

I have some vague memories about this.. any link to refresh my memory? ;-)
but right, the change seems ok

jirka
