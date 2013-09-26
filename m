Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3IZBZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:25:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33406 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZBZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:25:40 -0400
X-AuditID: cbfee68e-b7f756d000004512-ca-52438d135b8c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
 <000b01ceb9c4$1c77e0b0$5567a210$%han@samsung.com>
 <CAK9yfHwJ57sH5ZfsTYzXBhSHyaw4YtYnPo6636x11tedQBX2Qg@mail.gmail.com>
In-reply-to: <CAK9yfHwJ57sH5ZfsTYzXBhSHyaw4YtYnPo6636x11tedQBX2Qg@mail.gmail.com>
Subject: Re: [PATCH 02/20] regulator: ab8500: use devm_regulator_register()
Date: Thu, 26 Sep 2013 10:25:38 +0900
Message-id: <000301ceba57$4ef39370$ecdaba50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac652N9BLeAzF7vuRa+8T0kPZzzjvwAfb6ow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI13hXucgg0nXeSzWPzjGZDH14RM2
	i8sLL7FafLvSwWRxedccNouTf3oZHdg8ds66y+6xaVUnm8eda3vYPPq2rGL0+L50DbvH501y
	AWxRXDYpqTmZZalF+nYJXBn7D3QxFyznrJj07zRzA+Nzti5GTg4JAROJ9fM6WSFsMYkL99YD
	xbk4hASWMUosufadEabo2fzL7BCJRYwSG79uZIFwfjFKvFs8nwmkik1ATeLLl8PsILaIgI7E
	il1rmUCKmAXOM0qce7YeqmMHo8Sua8eZQao4BYIlOpe+AVsuLOAtcXLuVLBuFgFViYvzXoId
	yCtgK3FnzwNGCFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3gLN5AC6VV3i0V9diCOMJA4+7WWE
	KBGR2PfiHSPIDRICb9kl9p/rZobYJSDxbfIhFoheWYlNB5ghXpaUOLjiBssERolZSDbPQrJ5
	FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJIb7djDePGB9iDEZaP1EZinR
	5HxgCsgriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	AyNba4rKCe2YkuvLeS9J/5pQo/E4UFeNu3/iVX/7SZpdepZrDQ/YTlJqyslRUmXaO62zsu1J
	CfOp9PeP9qmw1ey9spJt99nLhZsPVa58/95357Y+taYvU+pXPqv8Eys4Y+UpO9mwqPlXFfRv
	c/+9wx8qkty0VYt706xPX+PVmbzZ1uRmz0qekqvEUpyRaKjFXFScCADajhjf9wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAV3hXucgg093OCzWPzjGZDH14RM2
	i8sLL7FafLvSwWRxedccNouTf3oZHdg8ds66y+6xaVUnm8eda3vYPPq2rGL0+L50DbvH501y
	AWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz9h/oYi5Yzlkx6d9p5gbG
	52xdjJwcEgImEs/mX2aHsMUkLtxbDxTn4hASWMQosfHrRhYI5xejxLvF85lAqtgE1CS+fDkM
	1iEioCOxYtdaJpAiZoHzjBLnnq2H6tjBKLHr2nFmkCpOgWCJzqVvWEFsYQFviZNzp4J1swio
	Slyc9xLsDl4BW4k7ex4wQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe8xZoJgfQreoSj/7qQhxh
	JHHwaS8jRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4ATxTGoH48oGi0OMAhyMSjy8F5idg4RYE8uKK3MPMUpwMCuJ8H4zAgrxpiRWVqUW
	5ccXleakFh9iTAZ6dCKzlGhyPjB55ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7
	NbUgtQhmCxMHp1QD44nF/VMzD59a+rOIf53pjP3JV1dlbf5fHVZp6MfMUuVxxfLvkbklYgsY
	2cu8tuSEW9yWShdbKTVfIdByqZG6ufDcr5sUHm+b+/pPa9ifowrSaxPzLDNeenoGC501Ybn9
	5rj3qTd+r9i2Kv4Mr9v6j3uaj7Ypf9ulZRtWbnY/wnJd0EzlzoqLfkosxRmJhlrMRcWJAJ2e
	o7xUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 25, 2013 7:21 PM, Sachin Kamat wrote:
> On 25 September 2013 13:21, Jingoo Han <jg1.han@samsung.com> wrote:
> > Use devm_regulator_register() to make cleanup paths simpler.
> 
> > -       for (i = 0; i < abx500_regulator.info_size; i++) {
> > -               struct ab8500_regulator_info *info = NULL;
> > -               info = &abx500_regulator.info[i];
> > -
> > -               dev_vdbg(rdev_get_dev(info->regulator),
> > -                       "%s-remove\n", info->desc.name);
> > -
> > -               regulator_unregister(info->regulator);
> > -       }
> > +       int err;
> >
> >         /* remove regulator debug */
> >         err = ab8500_regulator_debug_exit(pdev);
> 
> Wouldn't re-ordering (unregistering after ab8500_regulator_debug_exit)
> cause any problems here ?
> 

OK, I see. 
There is no ab8500_regulator_debug_exit() in the current kernel.
However, in my opinion, ab8500_regulator_debug_exit() should be
called, after regulator_unregister() is called.

I will remove this patch from next V2 patch series.
Thank you.

Bengt Jonsson,
If I am wrong, please let me know kindly. :-)

Best regards,
Jingoo Han

