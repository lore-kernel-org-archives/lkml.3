Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaAUPaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:30:13 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:30114 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAUPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:30:08 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-15-52de927e9439
Message-id: <52DE9274.1080806@samsung.com>
Date: Tue, 21 Jan 2014 08:29:56 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, rafael.j.wysocki@intel.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
 <15798389.lgk83XnI1i@vostro.rjw.lan>
In-reply-to: <15798389.lgk83XnI1i@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.7]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wn27dpHtBBgcfKlp0zrzGaHGi7wOr
	xeVdc9gs1j18wWTxeMVbdoszpy+xWuze9ZTV4utPB4v182+xOXB67Jx1l93jw8c4j8V7XjJ5
	vLpwh8Vjy9V2Fo8983+wehy/sZ3J4/MmuQCOKC6blNSczLLUIn27BK6M3uMzWQvWcVRs+lDR
	wPiarYuRk0NCwETicOd7JghbTOLCvfVAcS4OIYFljBKNl48yQTi9TBKXPv+AymxglGh6dAqs
	hVdAS2L9gYusIDaLgKrE0ikPmEFsNgF1ic+vd7CD2EICchJNS1aDxUUFIiRenZ3IAtErKPFj
	8j0wW0RAW2JuzylmkAXMAp8YJfYfPw+WEBbwlug4s4YJYlCWRMO0TrC7OQUMJe5OvQ82lFnA
	TOJRyzooW15i85q3zBD1yhJ/Lp+C+k1B4uXirSwTGEVmIdk9C0n7LCTtCxiZVzGKlRYnFxQn
	padWGOoVJ+YWl+al6yXn525ihERe1Q7GO19tDjEKcDAq8fAWrLobJMSaWFZcmXuIUYKDWUmE
	t2zCvSAh3pTEyqrUovz4otKc1OJDjEwcnFINjAwHMs6pvf90rvG+R+DG1Mgpsv6TfdX7A5oS
	XRZf5DTJMHRZwR+9Q4Fzh4+q1MrZlf/Srta0rvaf8v/yqZNTtwS7/OL7y3f736VVs17WNM5+
	zJnPcm36Xcsylj4/4aXXZ8SKvDvNudz5s9WNkrlXb8vf/Vwr+PY8lyRHYvzd1cEnbJaLCkVn
	NiqxFGckGmoxFxUnAgD8f3SymgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2014 08:37 AM, Rafael J. Wysocki wrote:
> On Wednesday, November 14, 2040 04:27:17 AM Shuah Khan wrote:
>> Convert drivers/video/backlight/class to use dev_pm_ops for power
>> management and remove Legacy PM ops hooks. With this change, rtc class
>> registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
>> Legacy class->suspend/resume. When __device_suspend() runs call-backs,
>> it will find class->pm ops for the backlight class.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> Cc: Shuah Khan <shuahkhan@gmail.com>
>
> Can you please resend the patches that nobody took with CCs to
> linux-pm@vger.kernel.org?  If the original maintainers don't care, I'll be
> able to pick those patches up then (if they look good).
>

Rafael,

Thanks. I have a few legacy pm patches that didn't get pulled into 
trees. I will rebase to the latest and resend.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
