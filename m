Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaDDLAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:00:36 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:55134 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaDDLAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAHTX3dLrfW_Hbqx_-vEfcHGCh7c4n=Hs1OATfvjJ9UEaxJTCaQ@mail.gmail.com>
References: <CA+G9fYuT4TSs=3j6K9zztsTgFNVp2YG6JT-2Q_L==1P5G+SBew@mail.gmail.com>
	<52FDE52A.4070002@linux.vnet.ibm.com>
	<CA+G9fYv9+Fhyz=nVZQZXxLU0YMTJadfr1XVVVb9P=inEfUaDuA@mail.gmail.com>
	<CAHTX3dLrfW_Hbqx_-vEfcHGCh7c4n=Hs1OATfvjJ9UEaxJTCaQ@mail.gmail.com>
Date: Fri, 4 Apr 2014 16:30:31 +0530
Message-ID: <CA+G9fYtFOPf6MYBKiOyHwSwZx5bHZWt3=Hzwsjrh5pvSarT+fw@mail.gmail.com>
Subject: Re: [LTP] How to get the Linux kernel coverage data on ARM arch when
 I run LTP test?
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, fhrbata@redhat.com,
        Paul Larson <paul.larson@canonical.com>,
        ltp-list <ltp-list@lists.sourceforge.net>,
        ltp-coverage <ltp-coverage@lists.sourceforge.net>,
        Mark Brown <mark.brown@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 March 2014 20:51, Michal Simek <monstr@monstr.eu> wrote:
> HI,
>
>
> 2014-02-18 15:30 GMT+01:00 Naresh Kamboju <naresh.kamboju@linaro.org>:
>
>> On 14 February 2014 15:13, Peter Oberparleiter
>> <oberpar@linux.vnet.ibm.com> wrote:
>> > On 14.02.2014 10:02, Naresh Kamboju wrote:
>> >> root@linaro-developer:/tmp/linux-linaro-3.13-2014.01# gcov
>> >> kernel/gcov/base.c -o
>> >>  /sys/kernel/debug/gcov/tmp/linux-linaro-3.13-2014.01/kernel/gcov/
>> >> File 'kernel/gcov/base.c'
>> >> Lines executed:43.18% of 44
>> >> Creating 'base.c.gcov'
>> >>
>> >> root@linaro-developer:/tmp/linux-linaro-3.13-2014.01#
>> >>
>> >> The above experiment gives coverage of a single file base.c when i run
>> >> gcov manually.
>> >> Is there any way to get Linux kernel coverage of all files after
>> >> running LTP test cases ?
>> >
>> > 1. Reset coverage data: lcov -z
>> > 2. Run LTP (or any other test case)
>> > 3. Capture coverage data: lcov -c -o coverage.info
>> > 4. Generate HTML output: genhtml coverage.info -o out
>> > 5. View HTML output: <browser> out/index.html
>>
>> It is working !!!
>> LTP executed on linux-linaro build on vexpress-tc2 target.
>> Please find results obtained
>> http://people.linaro.org/~naresh.kamboju/linux-linaro-coverage-by-ltp/
>>
>> The plan is to run all linaro test suite and to get coverage date.
>
>
> Have you already run it? Are these test cases available?


I have tested LTP on vexpress-tc2. I did not try all test suites.
We ( In Linaro) Linaro Test Suites is a package that contains test
suites that can be run in LAVA.
http://releases.linaro.org/14.03/components/platform/linaro-test-suites

>
> Thanks,
> Michal
>
