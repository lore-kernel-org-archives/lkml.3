Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978Ab3DCCQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:16:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62892 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3DCCQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:16:39 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-02-515b91059ef8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jongpill Lee'" <boyko.lee@samsung.com>,
        "'Jaecheol Lee'" <jc.lee@samsung.com>,
        "'Thomas Abraham'" <thomas.ab@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jonathan Kliegman'" <kliegs@chromium.org>,
        "'Michael Spang'" <spang@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1363711900-25560-1-git-send-email-dianders@chromium.org>
 <24b401ce300f$5a767b40$0f6371c0$%kim@samsung.com>
In-reply-to: <24b401ce300f$5a767b40$0f6371c0$%kim@samsung.com>
Subject: RE: [PATCH 0/2] These two patches to s3c_pm_arch_prepare_irqs() were
 part of the work
Date: Wed, 03 Apr 2013 11:16:37 +0900
Message-id: <24b501ce3011$454d3c70$cfe7b550$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kwh4+tmVwE2NsTjCjLWp9CdcbiQLTK8VgAAB46bA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zQ13WidGBBmffa1nsPreQzeLssoNs
	FhM/3GO06F1wlc1izvLF7BabHl9jtbi8aw6bxYzz+5gsbl/mtTh1/TObxc2HXSwWHcsYHXg8
	Wpp72DxmN1xk8di8pN7jyokmVo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DK2HjuPmPBFPaK
	PQuOMzcw7mftYuTgkBAwkfizkq+LkRPIFJO4cG89WxcjF4eQwDJGidPde1ggEiYSza/esEAk
	pjNKHDq7iBHC+csoMWlXFztIFZuAhsTh98/AbBGBYIln544ygxQxC7QzS+xf85QJJCEkUCnx
	+MwpsCJOATuJjXPXga0QFkiQ2DNlBlicRUBVovfqR0YQm1fAVqKv7zsbhC0o8WPyPbB6ZgEt
	ifU7jzNB2PISm9e8ZYZ4R13i0V9diBusJOZ/XQVVLiKx78U7sKMlBKZySEx/eRNql4DEt8mH
	WCB6ZSU2HWCG+FhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiY73ixNzi
	0rx0veT83E2MkKjv38F494D1IcZkoPUTmaVEk/OBSSOvJN7Q2MzIwtTE1NjI3NKMNGElcV61
	FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyFpq+yVx26bJx/v1x6/89lJ86o3e02lz1z
	NKjLXb7JiOXZBRuNKpWo0N3+9bLfDRS/GmcYPXj4ZYf/CalvPgeFsrjS3qR6rn6WU+DY8Gx3
	4V3VhIu3nVcvENm06LWWvNK9Y9YVhctT3I5tytLdtvLbjvxzVsmpW9LuLkgvzjH8zsn//rJj
	7hklluKMREMt5qLiRADlZ7PQEAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQV3WidGBBtvuqlrsPreQzeLssoNs
	FhM/3GO06F1wlc1izvLF7BabHl9jtbi8aw6bxYzz+5gsbl/mtTh1/TObxc2HXSwWHcsYHXg8
	Wpp72DxmN1xk8di8pN7jyokmVo++LasYPT5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6O
	d443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlFJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOE
	rm9IEFyPkQEaSFjHmLHx3H3GginsFXsWHGduYNzP2sXIySEhYCLR/OoNC4QtJnHh3nq2LkYu
	DiGB6YwSh84uYoRw/jJKTNrVxQ5SxSagIXH4/TMwW0QgWOLZuaPMIEXMAu3MEvvXPGUCSQgJ
	VEo8PnMKrIhTwE5i49x1YCuEBRIk9kyZARZnEVCV6L36kRHE5hWwlejr+84GYQtK/Jh8D6ye
	WUBLYv3O40wQtrzE5jVvgZZxAJ2qLvHory7EDVYS87+ugioXkdj34h3jBEahWUgmzUIyaRaS
	SbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxUnknvYFzVYHGIUYCDUYmH98SX
	qEAh1sSy4srcQ4wSHMxKIrynw6IDhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmPDySuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTCpjKdrgftzy9/f28XQci
	Nt4Lu9qw4FYQA7Nf0Fe/RftCNjREHbC1WdlXxBk8/1iDVMD76Zt4F5du/+swwc3KeeqdOcC0
	Wt1b+unQLscPGYc/9QYsFWV2/jSraV7n0Rf5X64/nSSjWTfNMkI65biq1wb9fPbq/yk1yoEx
	2YJsdzZo7axayO7RpqjEUpyRaKjFXFScCACugDoJbgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Doug Anderson wrote:
> >
> > to make suspend/resume reliable on the ARM Chromebook
> > (exynos5250-snow).
> >
> > A few more details:
> > - The first patch is not strictly needed but was a nice cleanup.  Our
> >   understanding was that EINT0 was originally turned on for exynos
> >   evt0 silicon and not needed for evt1.
> 
> Looks good to me, applied, thanks.
> 
> > - The second patch is more important and (also) more obvious.  The
> >   function was modifying the S5P_WAKEUP_MASK register and then
> >   clobbering its own modifications.
> >
> Applied with 1st one, BTW, do you want to send this for stable tree?
> 
One more note, just now I discussed Jaecheol Lee about the bit,
ENABLE_WAKEUP_SW, as the patch fixed, it should be cleared but used to be
set s3c_irqwake_intmask. Let me check again, then if any updates I'll let
you know.

Thanks.

- Kukjin

