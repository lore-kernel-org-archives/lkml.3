Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3FFJQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:16:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27373 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFJQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:16:15 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-4b-51b0535e4028
Date: Thu, 06 Jun 2013 11:16:06 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 1/5] cpufreq: Define cpufreq_set_drv_attr_files() to add
 per CPU sysfs attributes
Message-id: <20130606111606.38f9a074@amdc308.digital.local>
In-reply-to: <CAKohpo=fLmDog5KVjijEZNakpjLvrKy=S+nv+GQyCc2brcnO1w@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-2-git-send-email-l.majewski@samsung.com>
 <CAKohpokYdwutUX-zkHLs3bKmLg=Fb7WvKcwvfek9Q8k=XXs3bw@mail.gmail.com>
 <20130606105814.3495e3a9@amdc308.digital.local>
 <CAKohpo=fLmDog5KVjijEZNakpjLvrKy=S+nv+GQyCc2brcnO1w@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgG5c8IZAg/W7+Cz+vF3OavG06Qe7
	xbzPshadZ58wW7x5xG3x/tAzZovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx+1/j5k91k17y+zRt2UVo8ejxS2MHp83yQWwRXHZpKTmZJalFunbJXBlXPi0iKlgGUvF
	hK5jbA2MU5m7GDk5JARMJJa2nWGEsMUkLtxbz9bFyMUhJLCIUaJn7UYop51Jov/aURaQKhYB
	VYlNF0+CdbMJ6El8vvuUqYuRg0NEQEvi5c1UkHpmgV/MEi2vFjCDxIUF0iVebbMAKecVsJZY
	OXEJ2BhOgWCJ1q5nrCC2kMBBJon5r8FsfgFJifZ/P6COs5M492kDO0SvoMSPyffAepmBVm3e
	1sQKYctLbF7zlnkCo+AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	zDyT3sG4qsHiEKMAB6MSD69EwPpAIdbEsuLK3EOMEhzMSiK8u3w2BArxpiRWVqUW5ccXleak
	Fh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgnJvJILtuuf6XyxEONrr7P/I/0jzK
	u+H+CTMJK/dw4xv55u3muUu1Uoq3CPacyTmo4/7JYNP/VU+0r6jPjrRkm7nz5ekZ15fIbNz8
	11cik+9/tiJTZtzlyAfTlxUvZPW1n9r9M8U8ZXMUX6FvuJmM2dzp8j2/8//LJHg/Ya5/1LXf
	T6fEa36pEktxRqKhFnNRcSIADbhl8pUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 6 June 2013 14:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > I'm confused here.
> >
> > So you want to check dev_attr for NULL just after:
> > drv_attr = cpufreq_driver->attr;
> > if (!drv_attr)
> >         goto error;
> >
> > and skip the check at the while loop:
> > while ((drv_attr) && (*drv_attr))
> >
> > to
> >
> > while ((*drv_attr))
> >
> > Am I correct?
> 
> Bingo!!

Ok, no problem :-)

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
