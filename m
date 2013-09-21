Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3IUFwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 01:52:51 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53472 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3IUFwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 01:52:50 -0400
Message-ID: <523D333C.1090609@linux.vnet.ibm.com>
Date: Sat, 21 Sep 2013 11:18:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com> <CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com> <CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com> <CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com> <CACRpkdZDqoqrEPfdra+iVS-hopLpJbPmWh=r8UkYRFUMg17jpw@mail.gmail.com> <523C6A88.30800@linux.vnet.ibm.com> <CACRpkdasfW9OzZHPgfksjkHgw+Z-n7Tc_d2yXYy+BjShUhAYFg@mail.gmail.com> <CACRpkdbEdR6g7cGouSxVoCp7jFRUSmP9yKcu5+afEMqUR45Kfg@mail.gmail.com> <CAKohpokFzxaDt+oYY2tZXs3EBCRcByuv1buQECpdSzjN4e6x9g@mail.gmail.com>
In-Reply-To: <CAKohpokFzxaDt+oYY2tZXs3EBCRcByuv1buQECpdSzjN4e6x9g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092105-1396-0000-0000-0000039672FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 10:31 PM, Viresh Kumar wrote:
> On 20 September 2013 22:04, Linus Walleij <linus.walleij@linaro.org> wrote:
>> In this case we have neither. So the cpufreq driver fails to
>> register. But the kernel used to survive in any case, as you
>> could call cpufreq_get() without a cpufreq driver registered.
> 
> Aha, so exactly what I suspected in my first mail..
> 

Yep, your analysis was perfect right from the beginning :-)

Regards,
Srivatsa S. Bhat

