Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaIVPLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:11:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40694 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaIVPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:11:33 -0400
Subject: Re: [PATCH] modified error code when perf_session__new() fail
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: taeung <treeze.taeung@gmail.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, acme@kernel.org
In-Reply-To: <20140922134616.GC18187@krava.brq.redhat.com>
References: <541946D8.1080209@gmail.com> <1411227895.1690.23.camel@leonhard>
	 <20140922134616.GC18187@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Sep 2014 00:11:27 +0900
Message-ID: <1411398687.1665.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-09-22 (월), 15:46 +0200, Jiri Olsa:
> On Sun, Sep 21, 2014 at 12:44:55AM +0900, Namhyung Kim wrote:
> > That being said I'm okay with the patch itself.  Jiri, this is what you
> > wanted to do, right?
> 
> I have some vague memories about this.. any link to refresh my memory? ;-)

This is it: https://lkml.org/lkml/2014/8/13/331

Thanks,
Namhyung


> but right, the change seems ok
> 
> jirka



