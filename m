Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3HLFs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 01:48:59 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:32932 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab3HLFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 01:48:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,859,1367964000"; 
   d="scan'208";a="29090768"
Date: Mon, 12 Aug 2013 07:48:53 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel-janitors@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/16] drivers/cpufreq/pxa3xx-cpufreq.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
In-Reply-To: <CAKohponwknS=XaOXD7B+1J+YMSXgug7LXOz0ZgL5fVNetfqDfA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1308120748300.2038@localhost6.localdomain6>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr> <1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr> <CAKohpo=MfrUTYQKvJHP1Gns3kUfjqG6r9T8+7ZZ98-8yb0BZXw@mail.gmail.com> <alpine.DEB.2.02.1308120743030.2038@localhost6.localdomain6>
 <CAKohponwknS=XaOXD7B+1J+YMSXgug7LXOz0ZgL5fVNetfqDfA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Viresh Kumar wrote:

> On 12 August 2013 11:15, Julia Lawall <julia.lawall@lip6.fr> wrote:
> > I'm not sure to understand the sense of the question.
> 
> I was talking about this :)
> 
> (http://coccinelle.lip6.fr/)

The URL of the tool if you can't figure out all the funny notation below.

julia
