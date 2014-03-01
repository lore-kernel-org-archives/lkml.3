Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaCAD1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:27:37 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8560 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaCAD1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:27:36 -0500
X-AuditID: cbfec37d-b7f616d0000059df-d3-531153a764e6
Message-id: <5311539E.10305@samsung.com>
Date: Fri, 28 Feb 2014 20:27:26 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 0/3] media/drx39xyj: fix DJH_DEBUG path null pointer
 dereferences, and compile errors.
References: <cover.1393621530.git.shuah.kh@samsung.com>
 <CAGoCfiyZr2eCCW3ZmAE4_YUZw++NC3o-VY84M+n38tzfLdfBiQ@mail.gmail.com>
In-reply-to: <CAGoCfiyZr2eCCW3ZmAE4_YUZw++NC3o-VY84M+n38tzfLdfBiQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9hP93lwYLBBo8Oclrc2r2axeLyrjls
	Fj0btrJafP3p4MDisXPWXXaPucd6GT0+b5ILYI7isklJzcksSy3St0vgyni97ShLwQneir4p
	k1kbGDdydTFyckgImEjc6HzBCmGLSVy4t56ti5GLQ0hgGaPEmXd/2SGcXiaJF02fGCGcDYwS
	u7d2soC08ApoSBx4do8dxGYRUJU4fe41M4jNJqAu8fn1DrC4kICcRNOS1WBxUYEIiVdnJ0L1
	Ckr8mHwPzBYRMJbYfvE/2GpmgeWMEm2Pl4LdJCyQI3F91XE2iEF1EpfezgKLcwoES3yacR8s
	zixgLbFy0jZGCFteYvOat8wQ9coSfy6fYoL4TUHixsJlrBMYRWYh2T0LSfssJO0LGJlXMYqV
	FicXFCelp1aY6BUn5haX5qXrJefnbmKEREbtDsb7X20OMQpwMCrx8EosEggWYk0sK67MPcQo
	wcGsJML7O1AwWIg3JbGyKrUoP76oNCe1+BAjEwenVANj0aqzizcXh0fZqwkvTOD8JKjfW5jc
	2qXM336l69CVZRPDznZWbWXYcPNG+BLrZ70G/A/ZWlZe3f/dwyD4E2vzyeR7Qlpsa05MXv+6
	8Fjz7gD/RU5v/v72VF97QoXbYtEdVsFNv0zbV5s1BR3Kt/8s9OnyjP9bLs5weuT9tKJpar+T
	p1pOloi0EktxRqKhFnNRcSIATWGX7moCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 05:13 PM, Devin Heitmueller wrote:
> Seems kind of strange that I wasn't on the CC for this, since I was the
> original author of all that code (in fact, DJH are my initials).
>
> Mauro, did you strip off my authorship when you pulled the patches from
> my tree?
>
> The patches themselves look sane, and I will send a formal Acked-by once
> I can get in front of a real computer.
>
> Devin

Thanks for the ack. I will include you on the cc for future patches. I 
am working in Mauro's experimental git and probably that explains why 
get_maintainer.pl just showed linux-media and Mauro.

-- Shuah

>
> On Feb 28, 2014 4:23 PM, "Shuah Khan" <shuah.kh@samsung.com
> <mailto:shuah.kh@samsung.com>> wrote:
>
>     This patch series fixes null pointer dereference boot failure as well as
>     compile errors.
>
>     Shuah Khan (3):
>        media/drx39xyj: fix pr_dbg undefined compile errors when DJH_DEBUG is
>          defined
>        media/drx39xyj: remove return that prevents DJH_DEBUG code to run
>        media/drx39xyj: fix boot failure due to null pointer dereference
>
>       drivers/media/dvb-frontends/drx39xyj/drxj.c | 31
>     ++++++++++++++++++-----------
>       1 file changed, 19 insertions(+), 12 deletions(-)
>
>     --
>     1.8.3.2
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-media" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
