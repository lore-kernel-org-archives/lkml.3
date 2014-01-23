Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaAWSsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:48:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63907 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbaAWSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:48:13 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ea-52e163eba6fe
Message-id: <52E163DC.1090002@samsung.com>
Date: Thu, 23 Jan 2014 19:47:56 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140123180423.1a62611a@www.etchedpixels.co.uk>
 <20140123184022.GC11727@sirena.org.uk>
In-reply-to: <20140123184022.GC11727@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xK7qvkx8GGTyew2qxev0RFosHt1qZ
	LKY+fMJm0bx4PZvF59+7WC0u75rDZjHj/D4mizOLe9ktbl/mtWj/u5fNgcujpbmHzePZy8lM
	HptWdbJ53Lm2h81j/9w17B6tJzexepxZcITd4/MmuQCOKC6blNSczLLUIn27BK6Mjt7VrAWv
	WCqubt/I1MD4grmLkZNDQsBE4tizz6wQtpjEhXvr2boYuTiEBJYySsx5vpsFwvnMKHF40lw2
	kCpeAS2JPS+OgXWzCKhKHOr/xw5iswmoSXxueARWIyoQIfF33npGiHpBiR+T77GA2CICHhJ7
	rvaBbWAWeMok0fd/AlhCWCBKYvHOKUwQ2+4wSZx9/4AJJMEpYCyx6NsOsKnMAtYSKydtY4Sw
	5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkiUfN3B
	uPSY1SFGAQ5GJR7eD8EPg4RYE8uKK3MPMUpwMCuJ8DqaAYV4UxIrq1KL8uOLSnNSiw8xMnFw
	SjUwsoqpZUxiuH/o61/vQF3ljZNyKuXStr5IXyphEhDEL8eu8VF62Ru10EPlTWrR3yXjyrIZ
	Cu5G//621qLF4HXDn5VanHs3XVDYFXj30z6/hXK6XmHHzdxasxsr859sWLyFT0BetsXiRE91
	z86fKqq/w9ImbX7QEj/74kUmK+Ynbx4+mZKlXz9PiaU4I9FQi7moOBEAQYO3wnACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2014 19:40, Mark Brown wrote:
> On Thu, Jan 23, 2014 at 06:04:23PM +0000, Alan Cox wrote:
>
>> We can then enable that config option for ARM (and in time for any other
>> architecture that turns out to need/want it). Eventually it can go away
>> (not that its exactly doing any harm if it doesnt).
>
> We'd need to leave it user selectable rather than enabling it for ARM,
> the whole reason this got noticed is that people are trying to build
> kernels that support a wider range of devices for ARM.

What about making it depend on !MULTIPLATFORM and enabled by default?

Best regards,
Tomasz
