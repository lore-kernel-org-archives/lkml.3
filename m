Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3FFPOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:14:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53167 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3FFPOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:14:40 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-5c-51b0a75e8bfe
Date: Thu, 06 Jun 2013 17:14:31 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Dave Jones <davej@redhat.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5/5] cpufreq:boost:Kconfig: Enable boost support at Kconfig
Message-id: <20130606171431.41d63591@amdc308.digital.local>
In-reply-to: <20130606144910.GA1194@redhat.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-6-git-send-email-l.majewski@samsung.com>
 <20130606144910.GA1194@redhat.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+xgG788g2BBnu+sVn8ebuc1eJp0w92
	i3mfZS22XG9isug8+4TZ4s0jbovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx7ppb5k93u+7yubRt2UVo8ejxS2MHp83yQWwRXHZpKTmZJalFunbJXBlfJ3WyV7wnq3i
	8IRFrA2M81i7GDk5JARMJD7tameEsMUkLtxbz9bFyMUhJLCIUWLdrLXMEE47k8TsGX9YQKpY
	BFQlnr7oYQKx2QT0JD7ffQpmiwgoSpz5eQKsm1ngFbPEit/9zCAJYQF/iTnH17GD2LwC1hJb
	dk8Ci3MK6Etc3dYPNlRIYBmjxO9DaiA2v4CkRPu/H8wQJ9lJnPu0AapXUOLH5Htg9cwCWhKb
	tzWxQtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	HDfPpHcwrmqwOMQowMGoxMMrEbA+UIg1say4MvcQowQHs5IIr8zsDYFCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGDU/JSX23+qbeO/dUTvto2HmmZ8v
	PT/dUViZkLHsQ6re9h0TZ0kFuhxb/G5fd/+HPpm8QPMUg2DDl+kNvBt3l4drvrrBFaiS+NXT
	teRph6V5ZnVT/dEfWqGstfVWYhmBqU1qZs6z7u7lCRbb9pWb/3bC3POf5k1+5ZeTuuLqSvlo
	7xv3WzduVGIpzkg01GIuKk4EAN29ZjWXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> On Thu, Jun 06, 2013 at 09:07:52AM +0200, Lukasz Majewski wrote:
> 
>  > +config CPU_FREQ_BOOST
>  > +	bool "CPU frequency boost support"
>  > +	help
>  > +	  Switch to enable support for frequency boost
>  > +
>  > +	  If in doubt, say N.
>  > +
> 
> This help text is devoid of any useful information.
> 
> On what platforms ? What's the upside/downside ? Why is it an option ?

I shall be more verbose here.

The boost option is supposed to provide one solution to control
software based (like is is done with Samsung Exynos4 SoC) and hardware
based (like Intel's Turbo Boost feature) boost.

Support for Intel's boost is already in mainline. Therefore I aimed to
extend cpufreq to also manage software based solutions (e.g. Exynos).


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
