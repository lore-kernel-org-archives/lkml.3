Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbaFWQpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:45:55 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:63390 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbaFWQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:45:52 -0400
X-AuditID: cbfec37a-b7f206d000005572-26-53a859bf35c1
Message-id: <53A859AF.2010006@samsung.com>
Date: Mon, 23 Jun 2014 10:45:35 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 000/111] 3.12.23-stable review
References: <cover.1403512280.git.jslaby@suse.cz>
In-reply-to: <cover.1403512280.git.jslaby@suse.cz>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.210]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9hP939kSuCDY68E7T4/HsXq8XlXXPY
	LJ4sPMNkMfXUBBaLBRsfMTqweuycdZfdY+f3BnaPMwuOsHt83iQXwBLFZZOSmpNZllqkb5fA
	lfHg3xymgmNsFWendzE1MM5h7WLk5JAQMJFYe3AhE4QtJnHh3nq2LkYuDiGBZYwSu049YIZw
	epkkjr0F6QBxtjFKHPj1jwWkhVdAS+Ll4VlgNouAqsT+hzfBRrEJqEt8fr2DHcQWEpCTaFqy
	GmgSB4eoQITE4wtCEK2CEj8m3wNrFREwl3hw5wBYObNAicT151/YQGxhoPj7u/2sEGMMJe6t
	vsMIYnMKGEl8eveOGaLeTOJRyzooW15i85q3zBD1yhJ/Lp9iAlkrAWQf3cEzgVFkFpLNs5B0
	z0LSvYCReRWjWGlxckFxUnpqhaFecWJucWleul5yfu4mRkikVO1gvPPV5hCjAAejEg/vBefl
	wUKsiWXFlbmHGCU4mJVEeCNNVwQL8aYkVlalFuXHF5XmpBYfYmTi4JRqYKw8MmWLaIP5yyvv
	uD09pp67Ytz4IzModLXXEoU3v8SfpQS0JzZlOL232X7bjKfbrPRgRHJNl9IPa/ZLbOdfVm/r
	UNlTYLqNgSlcTvnU0dZExduJy27M9499x8OsPXdGLwdjZlOrndxR3x/1uy+s+Pm1M+fTS+22
	HV9PJor2iEt9mvP0z4q+BiWW4oxEQy3mouJEABkFintyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 02:32 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.23 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jun 25 08:31:21 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.23-rc1.xz
> and the diffstat can be found below.
>
> thanks,
> js
>

Compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
