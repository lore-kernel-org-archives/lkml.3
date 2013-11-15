Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3KOBDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:03:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41086 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3KOBDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:03:37 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-c0-528572e384a5
Message-id: <528572E2.9070606@samsung.com>
Date: Fri, 15 Nov 2013 10:03:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] extcon: arizona: Add defines for microphone
 detection levels
References: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkRPdxUWuQwfJWAYt/U26wW9z/epTR
	4vKuOWwWtxtXsFksf/ufzeJ0N6sDm8eda3vYPOadDPR4OfE3m0ffllWMHp83yQWwRnHZpKTm
	ZJalFunbJXBlbP/xi6VgEmvFpxVH2RoYp7B0MXJySAiYSLReOMcIYYtJXLi3nq2LkYtDSGAp
	o8T9iW+BHA6wojuLmCHi0xkluld/ZYdwXjFKTH70hQWkiFdAS+JqcwzIIBYBVYmFl76ygths
	QOH9L26wgdiiAmESK6dfAVvMKyAo8WPyPTBbRMBCYsqSW2ALmAX6GCUetcwEaxYWiJLY+nQh
	E4gtJBAqsbR7LlgDJ9CgE1degNUwC+hI7G+dxgZhy0tsXvMWbJCEwCl2iQ0zFrBAXCQg8W3y
	IRaIb2QlNh1ghvhYUuLgihssExjFZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCm9yFCvODG3uDQv
	XS85P3cTIzDSTv971ruD8fYB60OMyUArJzJLiSbnAyM1ryTe0NjMyMLUxNTYyNzSjDRhJXHe
	pIdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYo+4Z66TcC57Svfyax//5WtL2Gcc2i71a
	2JzrytJ9tGZtv96NE84ut0qLzdprV/42vr3S5OPT9z8vJfjbKjJejXXqXWgw5+HeKKd93zmC
	tP+944qdrqkhNfHJZNZ1TKGfFFRFD8bzCjvvFZOKzjB4bF/6WXflh12m/i/VHZv+/f7haT2J
	XXSGEktxRqKhFnNRcSIAjuA8bMoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd3HRa1BBksecFr8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b2H79YCiaxVnxacZStgXEKSxcjB4eE
	gInEnUXMXYycQKaYxIV769m6GLk4hASmM0p0r/7KDuG8YpSY/OgLWAOvgJbE1eYYkAYWAVWJ
	hZe+soLYbEDh/S9usIHYogJhEiunX2EBsXkFBCV+TL4HZosIWEhMWXKLGWQms0Afo8Sjlplg
	zcICURJbny5kArGFBEIllnbPBWvgBBp04soLsBpmAR2J/a3T2CBseYnNa94yT2AUmIVkxywk
	ZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzHz6R3MK5qsDjEKMDBqMTDGyHd
	GiTEmlhWXJl7iFGCg1lJhPdZAlCINyWxsiq1KD++qDQntfgQYzIwCCYyS4km5wNTTF5JvKGx
	iZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MBZeVzG9uPuxxBmV9bfv
	uqccLhHVlKvz+RwxMet1xK60VwW8XccKV07c/sJl57pixRunRb8lFl3fsG7X9yW3/G+lOh4r
	nBvzI8/PesGts72d//RfiM6VPzfnG++jl/8eXGHdU/yf4dSV+/339u9/PT3xKX9t/P4J8jlm
	E7zzLnaHcSbHhVjnvtNXYinOSDTUYi4qTgQA7QyG8icDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 11/15/2013 01:18 AM, Charles Keepax wrote:
> Improve readability by creating a define for each microphone detection
> level.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c       |   19 ++++++++++++++-----
>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 

Applied patch[1-5] on extcon-next branch.
I reply patch[6,7] with minor comment.

And, I'd like you to send cover-letter with patchset if you send multiple patches.

Thanks
Chanwoo Choi 

