Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3HLFqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 01:46:34 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62397 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3HLFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 01:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1308120743030.2038@localhost6.localdomain6>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr>
	<CAKohpo=MfrUTYQKvJHP1Gns3kUfjqG6r9T8+7ZZ98-8yb0BZXw@mail.gmail.com>
	<alpine.DEB.2.02.1308120743030.2038@localhost6.localdomain6>
Date: Mon, 12 Aug 2013 11:16:30 +0530
Message-ID: <CAKohponwknS=XaOXD7B+1J+YMSXgug7LXOz0ZgL5fVNetfqDfA@mail.gmail.com>
Subject: Re: [PATCH 12/16] drivers/cpufreq/pxa3xx-cpufreq.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-janitors@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 11:15, Julia Lawall <julia.lawall@lip6.fr> wrote:
> I'm not sure to understand the sense of the question.

I was talking about this :)

(http://coccinelle.lip6.fr/)
