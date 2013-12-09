Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3LII2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:28:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63654 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3LII2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:28:15 -0500
X-AuditID: cbfee61a-b7f796d000004313-95-52a57f1e7779
Date: Mon, 09 Dec 2013 09:28:09 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] cpufreq: exynos: Convert exynos-cpufreq to platform
 driver
Message-id: <20131209092809.691fb0f9@amdc2363>
In-reply-to: <CAK9yfHyFXHiTmYeS6N-rTktHPsXNC3SGE8-yyZW4i-txQXo1+w@mail.gmail.com>
References: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
 <1385642562-9339-1-git-send-email-l.majewski@samsung.com>
 <CAK9yfHyFXHiTmYeS6N-rTktHPsXNC3SGE8-yyZW4i-txQXo1+w@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAV25+qVBBqdeK1g8bfrBbvHmEbfF
	5V1z2Cw+9x5htDhz+hKrxck/vYwWG796OLB73Lm2h81j3bS3zB5brrazeHzeJBfAEsVlk5Ka
	k1mWWqRvl8CVse7/e6aCpRwVvRdOszcwPmbrYuTkkBAwkfhw8hA7hC0mceHeeqA4F4eQwCJG
	icUHZzJBOL8YJb7sn8MCUsUioCrR8vcEK4jNJqAn8fnuUyYQW0QgVOLo1K/sIA3MAs8YJX79
	mM4MkhAWCJF4/vAWWBEvUMOz9u9gqzkFgiUWzl7GDrHhKKPEy81nwTbwC0hKtP/7wQxxk53E
	uU8b2CGaBSV+TL4HVsMsoCWxeVsTK4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwUH/TGoH48oGi0OMAhyMSjy8K1iXBgmxJpYVV+YeYpTgYFYS
	4TWvAQrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgFDJn
	11j979vH93mHrn5+JqHMJLVji17Z/PSkv/c2rjYIKp7+6QHLutYMKaH+/8WOK4V8j4ppluVd
	PfFSb/oZo88SHzyv3tstssZdgu/onNvVQdKvFizpYOFWYG7Yc+e0pI9s+seSeWfZn9pHHrV6
	fPXRtWcysadU3d0en64yWS3zNHnbjn9i6UosxRmJhlrMRcWJAMAhc7R2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, Vires,

> On 28 November 2013 18:12, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > To make the driver multiplatform-friendly, unconditional
> > initialization in an initcall is replaced with a platform driver
> > probed only if respective platform device is registered.
> >
> > Tested at: Exynos4210 (TRATS) and Exynos4412 (TRATS2)
> >
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Looks good to me.
> Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Tested on Exynos5250 board.
> Tested-by: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Btw, Lukasz, can you please review my patch [1] which is similar to
> your changes done for 4210/4412.
> 
> [1] http://www.spinics.net/lists/linux-samsung-soc/msg24397.html
> 

Any comments on this patch? Is it suitable for pulling?


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
