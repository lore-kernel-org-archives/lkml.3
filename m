Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3GVIau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:30:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58947 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3GVIar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:30:47 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-9b-51ecedb574d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        "'Mike Galbraith'" <bitbucket@online.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
 <1373902022-20439-3-git-send-email-maxime.ripard@free-electrons.com>
 <003501ce81be$4a945ed0$dfbd1c70$@samsung.com>
 <1373945380.7549.26.camel@marge.simpson.net> <20130719083555.GC5106@lukather>
In-reply-to: <20130719083555.GC5106@lukather>
Subject: Re: [PATCH 2/3] video: hx8357: Make IM pins optional
Date: Mon, 22 Jul 2013 17:30:44 +0900
Message-id: <000301ce86b5$c280da30$47828e90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBBDsUjLqA0lXv1EE0kvWfH9ISAAEpSs6fAw/AWu8CQeinRAHEqU8vmMllIrA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zvu7Wt28CDbYsk7CYs34Nm0XHtcVM
	Fhf+L2a1ePJzPavF5YWXWC02Pb7GanGi7wOQu2sOm8XWTXuZLdY9fMFk8aJpB7sDt8esq7MZ
	PZ5susjo8erCHRaPEzN+s3hsXlLv8W7HSSaPvi2rGD0+b5IL4IjisklJzcksSy3St0vgynjz
	+zlrwWKeinntP9kaGNdzdjFyckgImEj0T5rGDmGLSVy4t56ti5GLQ0hgGaPEpLf72GCKehft
	ZoJILGKU2PV9BjuE84tR4vubj4wgVWwCahJfvhwGGyUikCDxs/s6WBGzwE0mic4/O8BGCQnM
	ZJI4vtC0i5GDg1NAV2LiTxeQsLCArcTc5efA5rAIqErMfXWFCcTmFbCUaP+9jBHCFpT4Mfke
	C4jNLKAlsX7ncSYIW15i85q3zBCXKkjsOPuaEeIGP4mt8zaxQ9SISOx78Y4R5B4JgYUcEoee
	vWGDWCYg8W3yIRaQeyQEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNoakFy
	QXFSepGhXnFibnFpXrpecn7uJkZIEujdwXj7gPUhxmSg9ROZpUST84FJJK8k3tDYzMjC1MTU
	2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjLnb10e0HUqRW/F/b9Xs
	NYccAm/KJ+5b9/cBz7FZ5QubpRjmn+/cfVta5mjdS7N0jV8b+3TDP6+8qeJk8/pZrsS/NsfZ
	/6Uljv5/XayXsl0j/+XP9gd6/7v7LJa/al18c/aD++x+IsdtVL9s/iVv3vr81ptJgUvWqc5/
	z7D+3L7nl1cJcl1YvqRYiaU4I9FQi7moOBEAdF5DTxgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAd2tb98EGny/ImQxZ/0aNouOa4uZ
	LC78X8xq8eTnelaLywsvsVpsenyN1eJE3wcgd9ccNoutm/YyW6x7+ILJ4kXTDnYHbo9ZV2cz
	ejzZdJHR49WFOyweJ2b8ZvHYvKTe492Ok0wefVtWMXp83iQXwBHVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SpkkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwjjHjze/nrAWLeSrmtf9ka2Bcz9nFyMkhIWAi0btoNxOELSZx
	4d56ti5GLg4hgUWMEru+z2CHcH4xSnx/85ERpIpNQE3iy5fD7CC2iECCxM/u62BFzAI3mSQ6
	/+xgA0kICcxkkji+0LSLkYODU0BXYuJPF5CwsICtxNzl58DmsAioSsx9dQVsM6+ApUT772WM
	ELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGuFRBYsfZ14wQN/hJbJ23iR2iRkRi34t3jBMY
	hWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwinkmvYNxVYPF
	IUYBDkYlHt6GgDeBQqyJZcWVuYcYJTiYlUR4PVcBhXhTEiurUovy44tKc1KLDzEmA306kVlK
	NDkfmP7ySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFRlGu/
	O9+auPN/9lhdCzsfJVN16OftrJSjX8+Ulm6XN9Wt8rmxS5jTklv8YLND4s4yP/tLM5d8Znnr
	rPvwXsabH6xBCq6zVmZbyq+fvCdL/yCX/5W2aUyfpzJu/x75YdalFdZH8k7oWvJ0LLpl5KOl
	9TxutgHTw7269/7/YlrB9eRvEM9S9XnzlViKMxINtZiLihMBavScuXUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 19, 2013 5:36 PM, Maxime Ripard wrote:
> On Tue, Jul 16, 2013 at 05:29:40AM +0200, Mike Galbraith wrote:
> > On Tue, 2013-07-16 at 09:49 +0900, Jingoo Han wrote:
> > > On Tuesday, July 16, 2013 12:27 AM, Maxime Ripard wrote:
> >
> > > > +
> > > > +			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> > > > +						    GPIOF_OUT_INIT_LOW, "im_pins");
> > >
> > > This makes a checkpatch warning such as 'WARNING: line over 80 characters'.
> > > How about the following?
> > >
> > > 			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> > > 						GPIOF_OUT_INIT_LOW, "im_pins");
> >
> > IIRC, some maintainers gripe (davem?) when they see such alignment,
> > preferring the original arg below arg alignment vs strict 80 column.
> 
> As far as I know, the coding guide styles are quite fuzzy about this:
>   - The new line is not required to be aligned with the braces above
>   - Yet, the emacs config given does indent like this.
>   - 80 characters is said not to be a hard limit

Even though 80 characters is not a hard limit, 80 characters is preferred
if possible.

> 
> I don't really know if there's a better solution here, except maybe:
> ret = devm_gpio_request_one(&spi-dev, lcd->im_pins[i],
> 			    GPIOF_OUT_INIT_LOW,
> 			    "im_pins");

Yes, I think that this can be used. :)


Best regards,
Jingoo Han

> 
> But it's not really a big deal, is it?
> 
> Maxime
> 
> --
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com

