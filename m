Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaLPGmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:42:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61813 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaLPGml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:42:41 -0500
X-AuditID: cbfee691-f79b86d000004a5a-f0-548fd45f6abe
Date: Tue, 16 Dec 2014 06:42:39 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [RFC RESEND 0/3] Add watermark support to devfreq
To: Alexandre Courbot <gnurou@gmail.com>,
        Arto Merilainen <amerilainen@nvidia.com>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "tomeu.vizoso@collabora.com" <tomeu.vizoso@collabora.com>,
        "javier.martinez@collabora.co.uk" <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "srasal@nvidia.com" <srasal@nvidia.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141216063845851@myungjoo.ham
Msgkey: 20141216063845851@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141216063845851@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1134564356.176631418712156720.JavaMail.weblogic@epmlwas06d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkSDf+Sn+IwYZTMhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj0LNetoInnBUz9+xgbGA8wNnFyMkhJKAusWjJSTYQW0LARGL2
	56dMELaYxIV764HiXEA1Sxklfi58yA5TNL/jIFRiDqPEzon3mEESLAKqEq/WvAWyOTjYBPQk
	Zn5OBgkLCzhJHPu4nxHEFhGIkJgx9zcjSC+zwBUWicaJexghrlCSWLPvFQuIzSsgKHFy5hMW
	kDkSQDMvv7OACKtJ7Fy6EupQcYkLcy9B3cMrMaP9KQuELScx7esaZghbWuL8rA2MMM8s/v4Y
	Ks4vcez2DqgnBSSmnjkIVaMlcf/GO1YIm09izcK3LDD1u04tZ4bZdX/LXKheCYmtLU/A6pkF
	FCWmdIPChwPI1pRYv0sf3Se8Ah4SG2YJg3wuITCVQ6JnwQzWCYxKs5CUzUIyaRbCJGQlCxhZ
	VjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEJoXT/55N3MF4/4D1IUYBDkYlHt6Awv4QIdbE
	suLK3EOMpsA4msgsJZqcD0w9eSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MB4pLP/he6RY36bEvMnpdvuWhDuJyzZ/bxZd9nJqtMhTh+k7WoIuJdgz
	3jnJc/HkhvNzlxuEnVZez9XyrEB03rMghlMs2w5P2Xavea+X2CstZ6mr4QnnKoss0gpTpmz9
	fVXVP37N0wRtfi2lH40b7s07wsputVbXfsvP6ldL7175eefMosjgvz+VWIozEg21mIuKEwHE
	OzKJBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tPt34K/0hBjNvi1pc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIxD
	z3rZCp5wVszcs4OxgfEAZxcjJ4eQgLrEoiUn2UBsCQETifkdB6FsMYkL99YD2VxANXMYJXZO
	vMcMkmARUJV4teYtkM3BwSagJzHzczJIWFjASeLYx/2MILaIQITEjLm/GUF6mQWusEg0TtzD
	CLFMSWLNvlcsIDavgKDEyZlPWEDmSADNvPzOAiKsJrFz6UqoG8QlLsy9xA5h80rMaH/KAmHL
	SUz7uoYZwpaWOD9rAyPMzYu/P4aK80scu72DCcIWkJh65iBUjZbE/RvvWCFsPok1C9+ywNTv
	OrWcGWbX/S1zoXolJLa2PAGrZxZQlJjS/ZAd5GRmAU2J9bv00X3CK+AhsWGW8ARG2VlIMrOQ
	NM9CaEZWsoCRZRWjaGpBckFxUnqFsV5xYm5xaV66XnJ+7iZGcAJ6tngH4//z1ocYBTgYlXh4
	Awr7Q4RYE8uKK3MPMUpwMCuJ8LpPBQrxpiRWVqUW5ccXleakFh9iNAXG2ERmKdHkfGByzCuJ
	NzQ2NjEzMbU0sTAwNVcS5/1/LjdESCA9sSQ1OzW1ILUIpo+Jg1OqgXFqRMF747yKHe8Zpr07
	naWx4q/PNsMLc4vO2M9iFy0VW503Kezk2dT5QvHLMryWW7ROzZTx2MPg0ijXLFW35poFc7SL
	+2/W2xM3XrcvWvzp0Lcw7etLmVbMcr+wzCLd5d2VDJ5Wu5cTj4c87vvP9Cfq7kaLmf3aGeyM
	N3l+3PF/+OOv+z2xOlElluKMREMt5qLiRACRGlE+VgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBG6gpXS004218

Alexandre Courbot:
> 
> MyungJoo, the issue of having this feature in the core vs. having it
> as a devfreq "extension" aside, do you agree with the core idea? An
> informl ack for the idea would allow us to start leveraging this for
> the ACTMON driver. With a concrete user it will make it easier for
> everyone to understand how the pieces should fit together.

Yes, I love the idea of event/interrupt-driven DVFS and I agree with
the core idea. The remaining concern is that the current "implementation"
might be too invasive to the subsystem while it does not need to be as
a governor can always choose not to poll. And the other issues are
quite minor as well.

Actually, it appears that next-generations of some architectures
(I think I cannot publically say which and when) are going to support
this for general peripherals on the bus and the CPU soon.


Cheers,
MyungJoo


>   
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
