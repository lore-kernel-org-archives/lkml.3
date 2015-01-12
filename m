Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbbALJ6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:58:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33256 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbbALJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:58:10 -0500
X-AuditID: cbfee68f-f791c6d000004834-ad-54b39aaf3b49
Date: Mon, 12 Jan 2015 09:58:07 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 00/10] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150112095342994@myungjoo.ham
Msgkey: 20150112095342994@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112095342994@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <437622256.904751421056684753.JavaMail.weblogic@epmlwas01a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkRHfDrM0hBvcLLS7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV0b31LdsBfu4K74/fsHSwDiFu4uRk0NIQF1i0ZKTbCC2hICJxKKP
	TVC2mMSFe+uBbC6gmqWMEjs2fWeFKXrwfRkjRGIOo8SMf9PYQRIsAqoSE7avAbI5ONgE9CRm
	fk4GMYUFUiRuTssCqRARyJO4cncGWCuzQA+bRMfV78wQRyhJrNn3igXE5hUQlDg58wkLxC5V
	iU2vX7BBxNUkGjf+hoqLS1yYe4kdwuaVmNH+FCouJzHt6xpmCFta4vysDYwwzyz+/hgqzi9x
	7PYOJghbQGLqmYNQNVoSHZNeQdXwSaxZ+JYFpn7XqeXMMLvub5kL1SshsbXlCThMmAUUJaZ0
	PwR7nVlAU2L9Ln10r/AKuEu87fzKAvK7hMBEDone040sExiVZiGpm4Vk1CyEUchKFjCyrGIU
	TS1ILihOSi8y1itOzC0uzUvXS87P3cQITAqn/z3r38F494D1IUYBDkYlHl4Lqc0hQqyJZcWV
	uYcYTYGRNJFZSjQ5H5h68kriDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwJh1VCLgtZdrZcU84UY9Zxlxn7Qpa+r0957/cOFSsH/1xyWuvQoB22VvtbbE
	bz0tJCD4oj7itKO3EsM2x7l7JgROe6Iid3UF675TDKluW46vidVjmXv6nNM8PacN94/UCP//
	+0d772amtNulYV8Kz64JeSIas4ItZE/1w9I4+Z8Gbn+4o2oK65RYijMSDbWYi4oTAc5b2XoF	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tPt31szaHGNxcYG5xedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jK6
	p75lK9jHXfH98QuWBsYp3F2MnBxCAuoSi5acZAOxJQRMJB58X8YIYYtJXLi3HijOBVQzh1Fi
	xr9p7CAJFgFViQnb1wDZHBxsAnoSMz8ng5jCAikSN6dlgVSICORJXLk7gxGklVmgh02i4+p3
	ZohdShJr9r1iAbF5BQQlTs58wgKxS1Vi0+sXbBBxNYnGjb+h4uISF+ZeYoeweSVmtD+FistJ
	TPu6hhnClpY4P2sD3M2Lvz+GivNLHLu9gwnCFpCYeuYgVI2WRMekV1A1fBJrFr5lganfdWo5
	M8yu+1vmQvVKSGxtecIKYjMLKEpM6X4I9jqzgKbE+l366F7hFXCXeNv5lWUCo+wsJKlZSLpn
	IXQjK1nAyLKKUTS1ILmgOCm9wkSvODG3uDQvXS85P3cTIzgFPVuyg7HhgvUhRgEORiUeXgup
	zSFCrIllxZW5hxglOJiVRHhdy4BCvCmJlVWpRfnxRaU5qcWHGE2BUTaRWUo0OR+YHvNK4g2N
	jU3MTEwtTSwMTM2VxHn/n8sNERJITyxJzU5NLUgtgulj4uCUamC88fO/dpCe9u9thflfpp0V
	23bsW9mH6+xWnr/Xp7ioiZ60snp04hJb5ET1uqhl2d8O31uyUPGij3rX8hDGJ2WfLQN4zx/l
	k+KVyD6/id30xN0HG3smtBd+nh21xsJXybV/e/XWzis2x0JXJsds83I0Ek8rfeIfNpHzwbxD
	Ff8Tp4ZpzPu1OWCGEktxRqKhFnNRcSIAtMimmFcDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C9wIrk017197

>   
>  This patchset add new devfreq_event class to provide raw data to determine
> current utilization of device  which is used for devfreq governor.
> 
> The following description explains the feature of two kind of devfreq class:
> - devfreq class (existing)
>  : devfreq consumer device use raw data from devfreq_event device for
>    determining proper current system state and change voltage/frequency
>    dynamically using various governors.
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor
> 

Question: Applying this patchset seems to imply that
drivers/devfreq/exynos/exynos_ppmu.c becomes obsolete.
How do you want to address it? Do you think it'd be ok to remove
thse obsolete drivers after your successing patchset?

If it is ok to remove old drivers after applying the new patchset,
please inclde a patch that removes old drivers unless such a removal
might result in compatibility issues with old (yet another obsolete)
board files, which I don't think probable.


Cheers,
MyungJoo.

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
