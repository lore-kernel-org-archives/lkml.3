Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3EQFRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 01:17:41 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:37541 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3EQFRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 01:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <1368624762.27262.1.camel@localhost>
References: <20130515132001.6cc824ba42106db973f90991@canb.auug.org.au>
	<1368624762.27262.1.camel@localhost>
Date: Fri, 17 May 2013 10:47:38 +0530
X-Google-Sender-Auth: ei_mGaAKa2F5VrZv7k7h2_jqSnw
Message-ID: <CAOh2x=nNNdgndfXCAQ7-oXDcuiNwAbNSb3_DgYuGsO8cPC__5g@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree (in
 Linus' tree)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Eric Paris <eparis@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 7:02 PM, Eric Paris <eparis@redhat.com> wrote:
> On Wed, 2013-05-15 at 13:20 +1000, Stephen Rothwell wrote:
>> Hi ,
>>
>> After merging the final tree, today's linux-next build (i386 defconfig)
>> produced this warning:
>>
>> kernel/auditfilter.c: In function 'audit_data_to_entry':
>> kernel/auditfilter.c:426:3: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]
>>
>> Introduced by commit 780a7654cee8 ("audit: Make testing for a valid
>> loginuid explicit") from Linus' tree.
>
> Thank you, I'll fix it up.  What am I likely missing that I don't see it
> on my builds?  I'm using gcc 4.8.  Is there a config option that enables
> additional warnings?

Is  this fixed? I couldn't find a relevant patch in linux-next/master for it.
