Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab3GWXRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:17:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54084 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386Ab3GWXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:17:48 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-c4-51ef0f1a8067
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-14-git-send-email-wsa@the-dreams.de>
 <CAErSpo4jazaN8YahJGs+KD1-j6o8QHe2LmiQwBY9+UweBVkHxQ@mail.gmail.com>
In-reply-to: <CAErSpo4jazaN8YahJGs+KD1-j6o8QHe2LmiQwBY9+UweBVkHxQ@mail.gmail.com>
Subject: Re: [PATCH 13/27] drivers/pci/host: don't check resource with
 devm_ioremap_resource
Date: Wed, 24 Jul 2013 08:17:46 +0900
Message-id: <004b01ce87fa$d77f9700$867ec500$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIWz9+gkgxze4NBzyMI+D6T3PBgIgKTGBZrAgBmGuGYvbjtAA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ10p/veBBvfW2VgsacqwuLzwEqvF
	5V1z2CzOzjvOZrHyxCxmB1aPBZtKPfq2rGL0OHnqCYvH501yASxRXDYpqTmZZalF+nYJXBlz
	F1oXLGSt2PtnCXMD4ySWLkZODgkBE4l7J9vZIWwxiQv31rN1MXJxCAksY5RoejSNHaboWddM
	RojEdEaJvp/7mSGcX4wSnxd9YwKpYhNQk/jy5TBYh4iAr8TzI02MIDazQLzE3ydH2SEa9jNK
	dE6ezwyS4BQIltjwqZcNxBYWiJO40rgTLM4ioCpxrfcBK4jNK2Ap8e3vRhYIW1Dix+R7LBBD
	tSTW7zzOBGHLS2xe85YZ4lQFiR1nXzNCHOEk8XPmMah6EYl9L96BvSAhcI5dYtuRI2wQywQk
	vk0+BFTEAZSQldh0AGqOpMTBFTdYJjBKzEKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRYZ6
	xYm5xaV56XrJ+bmbGCHx2buD8fYB60OMyUDrJzJLiSbnA+M7ryTe0NjMyMLUxNTYyNzSjDRh
	JXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MTDVV5UUq7rXGatkMlgb3/82/sdBj
	6xYT9VNJ+YETX+ju3KRlPPN+hPW0EJ3Fk4pd5JrWHkqOEVwnc+uMeJQH+8tXl/MT1IOWsOX5
	fpMuKU3VOp2yivvNjJtbdqz1O+k85+dyU9sXe7b/2Nku8tLs49LPHbvLpplpFXIlhhwJXvFh
	adePU2bzlFiKMxINtZiLihMB9oR4C+UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQV0p/veBBl8OWlgsacqwuLzwEqvF
	5V1z2CzOzjvOZrHyxCxmB1aPBZtKPfq2rGL0OHnqCYvH501yASxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZcxdaFyxkrdj7ZwlzA+Mkli5GTg4JAROJZ10zGSFsMYkL
	99azdTFycQgJTGeU6Pu5nxnC+cUo8XnRNyaQKjYBNYkvXw6zg9giAr4Sz480gXUzC8RL/H1y
	lB2iYT+jROfk+cwgCU6BYIkNn3rZQGxhgTiJK407weIsAqoS13ofsILYvAKWEt/+bmSBsAUl
	fky+xwIxVEti/c7jTBC2vMTmNW+ZIU5VkNhx9jUjxBFOEj9nHoOqF5HY9+Id4wRGoVlIRs1C
	MmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc/c+kdzCuarA4xCjAwajE
	w1sw612gEGtiWXFl7iFGCQ5mJRHeM5+BQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTEx5
	JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDovu2bTNnhDOY7
	X05VcD5/eygwhM3iZ/OM6uLcBy4bj6ZFn1PyaLn7vX0lq94V4+tmBY2PEtn+pFUseXctY16F
	qWpS06ES9XmHTM6GtrEGrDj05JCAospk242XvzV2HQ4Rj2s1LjundHQfW3iciXUkg/5mY/ZX
	Uh+mxzxd6JCse9886+aMosVKLMUZiYZazEXFiQBCd5dVQgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 3:13 AM, Bjorn Helgaas wrote:
> On Tue, Jul 23, 2013 at 12:01 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > devm_ioremap_resource does sanity checks on the given resource. No need to
> > duplicate this in the driver.
> >
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Jingoo, I can apply this, or if you have other pcie-designware.c
> updates this cycle, you can fold it into those.  Just let me know what
> you'd prefer.

Hi Bjorn Helgaas,

I will send other updates for pcie-designware.c.
I will fold it into those.
Thank you.

Best regards,
Jingoo Han



