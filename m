Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3ITInm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:43:42 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40192 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3ITInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <523B3E4B.6080003@linux.vnet.ibm.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<523AF50E.1040502@linux.vnet.ibm.com>
	<523B3E4B.6080003@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 10:43:40 +0200
Message-ID: <CACRpkdZ-p05Utwzd-z-Aj=KLyK2c_DuFL6QQE-kxje3F6PYScA@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 8:11 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:

> To confirm this, you can perhaps try out one commit before 474deff74 and see
> if it works for you. Or equivalently, you can apply the following patch
> (revert of 474deff74) over mainline and see if it works.

Actually I did try to revert that patch before, during trial-and-error ...
However it doesn't help, as I realized after bisecting it's commit
6eed940 that is causing this somehow...

Yours,
Linus Walleij
