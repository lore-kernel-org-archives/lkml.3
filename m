Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaAQPEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:04:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54538 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaAQPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:04:10 -0500
X-AuditID: cbfee68f-b7f156d00000276c-45-52d94668bdd4
Date: Fri, 17 Jan 2014 15:04:08 +0000 (GMT)
From: Saurabh Singh <saurabh1.s@samsung.com>
Subject: Re: [PATCH] Parse missing regulator constraints from device tree blob
To: Mark Brown <broonie@kernel.org>, rob.herring@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "celinux-dev@tree.celinuxforum.org" 
	<celinux-dev@tree.celinuxforum.org>,
        SREEVATSA D B <srevatsa@samsung.com>,
        Praveen BP <bp.praveen@samsung.com>
Reply-to: saurabh1.s@samsung.com
MIME-version: 1.0
X-MTR: 20140117150211389@saurabh1.s
Msgkey: 20140117150211389@saurabh1.s
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140117150211389@saurabh1.s
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <29524060.615241389971045531.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42JZI2JSpZvhdjPIoK1HyOLyrjlsDowenzfJ
	BTBGcdmkpOZklqUW6dslcGXMuelf8EyyYs6ErAbGHskuRk4OIQFVidl7tjB2MXJwSAiYSLxe
	VwgSlhAQk7hwbz1bFyMXUMlSRok1PQ9YIBImEh/6DzJC9M5nlLhzPhyklwVozvItNSBhNgFd
	iYfr77KD2MICfhJ7Wj4ygdgiAi4S00+cZQKZySywmlmiYe4SNog5ChLnnneCFfEKCEqcnPkE
	apeyxOOGacwQcRWJ2+8WsULE5SSWTL3MBGHzSsxof8oCE5/2dQ0zhC0tcX7WBkaYZxZ/fwwV
	55c4dnsHE8S/vBJP7gfDjNm9+QsbhC0gMfXMQahWDYm2NUugWvkk1ix8ywIzZtep5cwwvfe3
	zAU7h1lAUWJK90N2CNtA4siiOayo3uIAsp0kFq/wnsCoPAtJZhaS7llIupHVLGBkWcUomlqQ
	XFCclF5krFecmFtcmpeul5yfu4kRmA5O/3vWv4Px7gHrQ4zJwBiZyCwlmpwPTCd5JfGGxmZG
	FqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRLcXw6f9qxm2+
	9jriHuenfcpReWJiuTNcYa3uXJlHCX81Prbd/5aqI+D0N9f0Wqa+w0H3g7x3/Nbe3vnuodJt
	hiKV3xpXlqUu2tZcJDHRvbJpiq7y553h1bN5lq3YvsnEZmbfXUPvF9VnuXetZbr6g01RUcHg
	Qt61ld0vlP5qW35ec27KbfdpSizFGYmGWsxFxYkAu7VdSx0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t/tGboZbjeDDDbO5rK4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRlz
	bvoXPJOsmDMhq4GxR7KLkZNDSEBVYvaeLYwgtoSAicSH/oNQtpjEhXvr2SBq5jNK3Dkf3sXI
	wcECVL98Sw1ImE1AV+Lh+rvsILawgJ/EnpaPTCC2iICLxPQTZ4FsLg5mgdXMEg1zl0DNUZA4
	97wTrIhXQFDi5MwnLBC7lCUeN0xjhoirSNx+t4gVIi4nsWTqZSYIm1diRvtTFpj4tK9rmCFs
	aYnzszbA3bz4+2OoOL/Esds7mEBuBul9cj8YZszuzV/YIGwBialnYN7VkGhbswSqlU9izcK3
	LDBjdp1azgzTe3/LXLBzmAUUJaZ0P2SHsA0kjiyaw4rqLQ4g20li8QrvCYxys5BkZiHpnoWk
	G1nNAkaWVYyiqQXJBcVJ6RXGesWJucWleel6yfm5mxjBaenZ4h2M/89bH2IU4GBU4uGVEL8R
	JMSaWFZcmXuIUYKDWUmEd47BzSAh3pTEyqrUovz4otKc1OJDjMnA+JvILCWanA9MmXkl8YbG
	JuamxqYWBobm5makCSuJ88bfSgoSEkhPLEnNTk0tSC2C2cLEwSnVwBjwgzdw9cKC+lX2Xc8N
	70VGiLtqGdZW677Qux6f5b1VKzAulOW57Xe+D4FbmsxjzB4fzb9w/PqkQ4cfL/jH68El3XDr
	tfC1z8qxdTmmD7M2G135U33R6LzTUd4PZlP8A4zcYne8ma7Lkm9rmdjtvriAT+98cnN6S5pw
	yo/suLjZrc7ei3RWKLEUZyQaajEXFScCADZj3TWPAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HF5E1N025385

Hi Mark,

> No, please do as I asked and follow the process in SubmittingPatches - as I
> said the format things are sent in is very important for the tooling.  Pasting
> the patch into a mail after some other text definitely doesn't give a mail in
> the format covered in SubmittingPatches.  If in doubt send the mail to
> yourself and then compare it with other patches sent to the list and test by
> applying with git am and make sure the patch and changelog come out OK.

Ok, I have created the patch with guidelines, which I will be sending in a separate mail 
Also, this time I have tested my patch it by "git am".

> > +- regulator-valid-modes-mask: valid operations for regulator on
> > +particular machine
> 
> This is not adequately documented, what are "valid operations" and how
> would they be encoded?

Provide the information in documentation, and provide better abstraction so as to hide
linux internals in device tree.

> > +- regulator-input-uv: regulator input voltage, only if supply is
> > +another regulator
> 
> Why provide a property for this, surely if there is another regulator we can
> just find out from that regulator what voltage it is outputting?

Valid point! , removed from the code.

> > +- regulator-initial-mode: default mode to set on startup
> 
> It is not documented what a mode is here or how one would specify it in the
> property.
> 
> > +- regulator-initial-state: suspend state to set at init
> 
> Again, no semantics are provided for this.

Added documentation with example

> I am very nervous about the idea of putting this stuff into DT.  This matches
> less and less well with modern system designs which are becoming more and
> more dynamic, and of course the concepts of suspending to memory, disk
> and standby are unclear and fluid - what is the difference between memory
> and standby for example?
> 
> I'd be interested to know if there are real systems that need this and can't
> figure out what to do dynamically.

We often use suspend to memory  in our mobile domain and is much useful.
Suspend to disk could be useful for special cases of hibernate like debugging.
Couldn't find the use of standby constraint, but I added in code so as to provide completeness to the framework. 

Please let me know your feedback.

Regards,
Saurabh Singh Sengar
Lead Engineer
Samsung R&D Institute
India
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
