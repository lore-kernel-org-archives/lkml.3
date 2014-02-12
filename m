Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaBLStW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:49:22 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:50972 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaBLStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:49:20 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-f5-52fbc22fac98
Message-id: <52FBC226.8030607@samsung.com>
Date: Wed, 12 Feb 2014 11:49:10 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
References: <20140211184823.492407127@linuxfoundation.org>
In-reply-to: <20140211184823.492407127@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX139Q7+DDDZuULGYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvjbn9ZwTGuiqbl/YwNjDs4uhg5OSQETCTuHdzHDmGLSVy4t54NxBYSWMYo0bNJrYuR
	C8juZZLYePMWK4SzgVFi5vl3TCBVvAJaEic3nQbrZhFQlejbtJIRxGYTUJf4/HoHO8QkOYmm
	JauZQWxRgQiJV2cnskD0Ckr8mHwPzBYRCJZY+3UhI8gCZoEVjBLHX74EO0NYwEyibWkXE8Qg
	K4lTL/aCxTkFrCUeb21lBbGZgWoetaxjhrDlJTavecsMUa8s8efyKSaI1xQk1l84zDqBUWQW
	kt2zkLTPQtK+gJF5FaNYaXFyQXFSemqFkV5xYm5xaV66XnJ+7iZGSMxU72C8+9XmEKMAB6MS
	D6/Fst9BQqyJZcWVuYcYJTiYlUR4jZqBQrwpiZVVqUX58UWlOanFhxiZODilGhjnxZ8udt64
	7UCq7Fq760Kld6cLm/wQSvf7k9C+RiZh0dtHls58W6Zdmqu2K7Qg282PebfOwYhJQY+XXGE8
	pzfz0N9rZ7WD0nYLPby3Vzf/C1u1xc7PO/lPXrbim1l6UEL/9BErI6YJSWsveE28K3WssXLK
	nbr2U+w86358Fl/5aeGcKoHSE8zHlViKMxINtZiLihMBMXTncHcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 12:04 PM, Greg Kroah-Hartman wrote:
> Some -stable releases spring out from my build system bright and shiny
> and ready to go.  Not so with these releases.  Maybe it's the horrid
> weather that was happening during the creation of these kernels, or
> something else, but whatever it was, they came into this world
> screaming, kicking, killing build servers left-and-right, and breaking
> the build every other patch.  Some developers decided to get into the
> act, constantly pushing the boundaries of what is an acceptable -stable
> patch, and trying to skirt the rules of upstream patches first numerous
> times, making me even grumpier than normal, "forcing" me to relax and
> take in an afternoon playing of the Lego movie...
>
> Test these out well, they have barely survived my systems, and I don't
> trust them in the slightest to not eat your disks, reap your tasks, and
> run away laughing as your CPU turns into a space heater.
>
> You have been warned.
>
> -----------------
>

Worked fine on all my test systems. Compile tests and boot tests passed. 
No dmesg regressions: emerg, crit, alert, err are clean. No regressions 
in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
