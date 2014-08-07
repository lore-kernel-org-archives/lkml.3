Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaHGQNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:13:19 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:47032 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:13:17 -0400
X-AuditID: cbfec37c-b7fde6d000000c64-48-53e3a59c9389
Message-id: <53E3A599.6090008@samsung.com>
Date: Thu, 07 Aug 2014 10:13:13 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] kbuild: kselftest - new make target to build and run
 kernel selftests
References: <1407420192-4928-1-git-send-email-shuah.kh@samsung.com>
 <20140807155713.GA1382@ravnborg.org>
In-reply-to: <20140807155713.GA1382@ravnborg.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.247]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX905Sx8HG0xdKmHRvHg9m8WfXTuY
	LC7vmsNm0bLvApPFip9bGR1YPfbPXcPusWTaVTaPMwuOsHt83iQXwBLFZZOSmpNZllqkb5fA
	lfFw/i6mgn3cFQtv97E3MDZwdjFyckgImEgcudvJDmGLSVy4t56ti5GLQ0hgGaPEno8TmCGc
	XiaJhv1tjBDONkaJidNmMoK08ApoSZy9c4IVxGYRUJU4dGcCE4jNJqAu8fn1DrCxQgJyEk1L
	VjOD2KICERIH+p6xQvQKSvyYfI8FxBYRUJY4fv4aK8gCZoF+RolLB96CFQkLxEtcevuTEWJQ
	lsTspj9gcU4BQ4n+rTvBmpkFrCVWTtrGCGHLS2xe85YZol5Z4s/lU0wQvylLbNxzm20Co8gs
	JLtnIWmfhaR9ASPzKkax0uLkguKk9NQKY73ixNzi0rx0veT83E2MkHip2cF476vNIUYBDkYl
	Hl6LpkfBQqyJZcWVuYcYJTiYlUR4dbsfBwvxpiRWVqUW5ccXleakFh9iZOLglGpgzHX9Ec8Z
	JePivMe3/gPTNq6MF7ua5jNr7Fty/sF3g59RcwtjlReKVezl2V+jHnbV9NiHY0aGR/70LmCW
	iLDW/S6Wf4ll7aOj/2M+SfVqlX86vNI/+5k6g4vEh81tmT4/mb71RHzkXbjtpMy/sjtKTBlf
	lMRm5/eurb6Stat82seGqxnqkk+7lViKMxINtZiLihMBkqREzXUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 09:57 AM, Sam Ravnborg wrote:
> On Thu, Aug 07, 2014 at 08:03:12AM -0600, Shuah Khan wrote:
>> Add a new make target "kselftest" to enable kernel testing. This
>> new target builds and runs kernel selftests. Running as root is
>> recommended for a complete test run as some tests don't run when
>> run by non-root user.
>
> kselftest will run the test - but will not build the kerenl.
> That is does not build the kernel is IMO a good thing -
> as one may re-run the test while doing work on the kernel, and triggering
> a rebuild to re-run the test is not nice.

Good. That is the reason why I made the change to not run make all.
Result of an aha moment when I was working on the v2 :)

>
> The changelog + help text needs to be updated to reflect that the kernel is not
> built when you use "make kselftest".

I will update the changelog and re-send the patch.

>
> On top of this - can you please tell what plans exists to extend this.
> When we discussed "devtest" it was said that it would not be a wrapper
> for selftests run_tests only, but more was planned to be added.
>

I posted agenda item to ksummit-discuss this morning outlining the
progress made in 3.17 and what's planned for 3.18 and beyond. I think
the post is waiting for moderator approval.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
