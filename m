Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3IUFvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 01:51:13 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60677 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3IUFvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 01:51:12 -0400
Message-ID: <523D32D9.5020603@linux.vnet.ibm.com>
Date: Sat, 21 Sep 2013 11:17:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com> <CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com> <CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com> <CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com> <CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com> <523C66C5.9040008@linux.vnet.ibm.com> <CAKohpo=b8WiE5kY8u4d5RDtJazR-U+NMR1jJTS85wTc9hvkGYA@mail.gmail.com>
In-Reply-To: <CAKohpo=b8WiE5kY8u4d5RDtJazR-U+NMR1jJTS85wTc9hvkGYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092105-6102-0000-0000-000004364884
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 10:24 PM, Viresh Kumar wrote:
> On 20 September 2013 20:46, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> I think show() and store() also suffer
>> from a similar fate. So do you think we need to add these checks there as well?
>> I'm not sure, since I can't think of a situation in which show() or store()
>> can be invoked before the cpufreq-driver is registered.. or, is such a
>> situation possible with cpufreq_disabled()?
> 
> cpufreq_disabled() is supposed to be called at boot time, so that
> cpufreq_core_init() fails.. and so show/store wouldn't exist without
> a driver..
> 

Ah, ok..

Regards,
Srivatsa S. Bhat

