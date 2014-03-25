Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaCYAQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:16:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29810 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaCYAPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:15:42 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-e9-5330caab4c22
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Haavard Skinnemoen'" <hskinnemoen@gmail.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-15-git-send-email-alexandre.belloni@free-electrons.com>
 <20140319142231.GF20872@samfundet.no>
 <000101cf449f$aa609960$ff21cc20$%han@samsung.com>
 <20140324155412.GA9083@piout.net>
In-reply-to: <20140324155412.GA9083@piout.net>
Subject: Re: [PATCH 14/16] backlight: atmel-pwm-bl: remove obsolete driver
Date: Tue, 25 Mar 2014 09:15:39 +0900
Message-id: <001501cf47bf$5a88e3c0$0f9aab40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9HeU51ikZdMtUQQhq4TDMHIB2VmAARbTiA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zA93VpwyCDeb1mll0XFvMZHF050Qm
	i5eHNC261z1it2hevJ7N4sfXZhaLywsvsVpsenyN1eJE3wdWi8u75rBZbH2zjtHi7t1VjBbf
	LjezW6x7+ILJYveup6wWP3fNY3EQ8FjwayuLx5NNFxk9ds66y+7x6sIdFo/9c9ewe2xeUu+x
	Z/4PVo9Fpz6ze/RtWcXo8XmTXABXFJdNSmpOZllqkb5dAlfGucsdLAXLuSpOnbvG1sDYzdHF
	yMkhIWAicelYLyOELSZx4d56NhBbSGAZo8TlbYwwNQ82PWLuYuQCik9nlFjxuQ/K+c0osebH
	BCaQKjYBNYkvXw6zg9giArkSB/6dYwQpYhboY5E4vPo+O0THIiaJs9s2g1VxCuhJ9Gy8DWYL
	C3hJzPy6E2gsBweLgKrEsaX5IGFeAVuJrs0H2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kL
	1iohoC7x6K8uxA1GEl3zz0CViEjse/EO7B4JgQscEgdaP4HNYREQkPg2+RALRK+sxKYDzBAf
	S0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRGS
	Rnp3MN4+YH2IMRlo/URmKdHkfGAayiuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGRp91SywfqW/VPbLq9alU6XOy1X6rv06c+Xlz+NxZrzfdmVL3
	NVrw6vG0lXqMJ8TVSj6tC5vvvKM3QeWQEdM7kX6+NfLOMkyzDyVsmMXF8KHR+oFr6JO7Vmrc
	HzbOD3/7/Fi837vQJVK5qkkp/idWTmt/EHKpfsXjg4/lN1ZYPUjaZP1PryYr0kGJpTgj0VCL
	uag4EQDEm72SOQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e+xoO7qUwbBBvNf6lt0XFvMZHF050Qm
	i5eHNC261z1it2hevJ7N4sfXZhaLywsvsVpsenyN1eJE3wdWi8u75rBZbH2zjtHi7t1VjBbf
	LjezW6x7+ILJYveup6wWP3fNY3EQ8FjwayuLx5NNFxk9ds66y+7x6sIdFo/9c9ewe2xeUu+x
	Z/4PVo9Fpz6ze/RtWcXo8XmTXABXVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	wjrGjHOXO1gKlnNVnDp3ja2BsZuji5GTQ0LAROLBpkfMELaYxIV769m6GLk4hASmM0qs+NzH
	DOH8ZpRY82MCE0gVm4CaxJcvh9lBbBGBXIkD/84xghQxC/SxSBxefZ8domMRk8TZbZvBqjgF
	9CR6Nt4Gs4UFvCRmft0JNJaDg0VAVeLY0nyQMK+ArUTX5oNsELagxI/J91hAbGYBLYn1O48z
	QdjyEpvXvAVrlRBQl3j0VxfiBiOJrvlnoEpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKepZ9I7GFc1WBxiFOBgVOLh3WBqECzEmlhWXJl7
	iFGCg1lJhPf+RqAQb0piZVVqUX58UWlOavEhxmSgPycyS4km5wNTaF5JvKGxiZmRpZGZhZGJ
	uTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MFZn7QhkeJ9vviTyzqFzviVda+TY8pw3
	y/H+kdmctTX2Lcez9pszcw227NzKZzEp4eUDsfUnnrdKvBPmvOB5tzlOdacRoxy7xZbPH5JZ
	sxTty29WdesFODMXTTDfu+ftXrvJTA2/Nja0mFwUsYoI80w+J+2sa7p1wQajezy7Jv3a+rzB
	cwbbciWW4oxEQy3mouJEAGnVdRyXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 25, 2014 12:54 AM, Alexandre Belloni wrote:
> On 21/03/2014 at 09:51:16 +0900, Jingoo Han wrote :
> > On Wednesday, March 19, 2014 11:23 PM, Hans-Christian Egtvedt wrote:
> > > Around Wed 19 Mar 2014 14:03:27 +0100 or thereabout, Alexandre Belloni wrote:
> > > > The atmel-pwm-bl driver is now obsolete. It is not used by any mainlined boards
> > > > and is replaced by the generic pwm_bl with the pawm-atmel driver using the
> > > > generic PWM framework.
> > > >
> > > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > >
> > > Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> >
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> >
> 
> You didn't comment on patch 08/16, are you fine with it ? I guess this
> is the only one holding back the full series.

'drivers/video/backlight/pwm_bl.c' is Thierry Reding's domain,
as follows.

  PWM SUBSYSTEM
  M:      Thierry Reding <thierry.reding@gmail.com>
  L:      linux-pwm@vger.kernel.org
  S:      Maintained
  .....
  F:      drivers/video/backlight/pwm_bl.c

So, it is required to get Ack from Thierry Reding.

Best regards,
Jingoo Han

> 
> Regards,
> 
> --
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

