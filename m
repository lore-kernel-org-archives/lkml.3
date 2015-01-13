Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbbAMJOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:14:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59478 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbAMJOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:14:08 -0500
X-AuditID: cbfee691-f79b86d000004a5a-51-54b4e1de27b5
Date: Tue, 13 Jan 2015 09:14:06 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv3 3/8] ARM: dts: Add memory bus node for Exynos3250
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
X-MTR: 20150113091350575@myungjoo.ham
Msgkey: 20150113091350575@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150113091350575@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <823139081.971381421140443531.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkUPfewy0hBn8261tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MIy+WsRWs4q54ubqJpYGxgbuLkZNDSEBdYtGSk2wgtoSAicSD
	90+ZIGwxiQv31gPFuYBqljJKTNxwnbmLkQOs6OJEe4j4HEaJrUs3sYM0sAioSlw9/ZURpIZN
	QE9i5udkEFNYwF1i8lsLkAoRgTyJK3dnMIK0Mgv0sEl0XP3ODHGDksSafa9YQGxeAUGJkzOf
	sECsUpVYu6oIIqwmsel8AwvEaeISF+ZeYoeweSVmtD+FistJTPu6hhnClpY4P2sDI8wri78/
	horzSxy7vQPqRQGJqWcOQtVoSWx/uhpqJp/EmoVvWWDqd51azgyz6/6WuVC9EhJbW56wgtjM
	AooSU7ofsoOczCygKbF+lz6qT0Bsd4lDzy+ygLwuITCTQ2Jx7zW2CYxKs5DUzUIyahbCKGQl
	CxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEpoTT/55N3MF4/4D1IUYBDkYlHt4d2VtC
	hFgTy4orcw8xmgLjaCKzlGhyPjDx5JXEGxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwFgZInJ2m1/wzaZjs56bZCdo7nQon5pfGjqXfX1S/u9Ey4+zeecw
	qop5/Xgb/fHBpB01i0szt0g2Tc6IU20I/6W3teVd7ZYkSf/JOdKlZbs+/p7564z9dL0ji298
	F3UqdC1hMGr6fO+JoHn0wV8/G/Q3N863Lfesl4u/ybFyYdSXpK4XJyxWFymxFGckGmoxFxUn
	AgDZWuJBBAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t/tXt17D7eEGPz7r2lxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jKO
	vFjGVrCKu+Ll6iaWBsYG7i5GTg4hAXWJRUtOsnUxcnBICJhIXJxoDxKWEBCTuHBvPVCYC6hk
	DqPE1qWb2EESLAKqEldPf2UEqWcT0JOY+TkZxBQWcJeY/NYCpEJEIE/iyt0ZjCCtzAI9bBId
	V78zQ6xSkliz7xULiM0rIChxcuYTFoi1qhJrVxVBhNUkNp1vYIE4QVziwtxL7BA2r8SM9qdQ
	cTmJaV/XMEPY0hLnZ21ghDl58ffHUHF+iWO3dzBB2AISU88chKrRktj+dDXUTD6JNQvfssDU
	7zq1nBlm1/0tc6F6JSS2tjxhBbGZBRQlpnQ/ZAc5mVlAU2L9Ln1Un4DY7hKHnl9kmcAoOwtJ
	ahaS7lkI3chKFjCyrGIUTS1ILihOSq8w0itOzC0uzUvXS87P3cQITj/PFu1g/Hfe+hCjAAej
	Eg/vjuwtIUKsiWXFlbmHGCU4mJVEeOffBgrxpiRWVqUW5ccXleakFh9iNAXG2ERmKdHkfGBq
	zCuJNzQ2NjEzMbU0sTAwNVcS5/1/LjdESCA9sSQ1OzW1ILUIpo+Jg1OqgZGfOVnkcZXg9eZp
	rZtC5n31XqP7Qeri7j37pgbl/fse+GiDwvJip9c6x1/+2eN14L+lWN0r9U3Tz+ocObBq3/ty
	yb1axaalgrzH6i2UxaMO+z9jepT0sjBYXnjuNCODN93ss03XX31xYJb2tTU1rIa6Zv3NOpzH
	XHQ9T764KPt7Wsban2GXvrIqsRRnJBpqMRcVJwIANEWBUFUDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D9Ee6L026423

>   
>  This patch adds the memory bus node for Exynos3250 SoC. Exynos3250 has
> following memory buses to translate data between DRAM and eMMC/sub-IPs.
> 
> Following list specifies the detailed relation between memory bus clock and DMC
> IP in MIF (Memory Interface) block:
> - DMC clock : DMC (Dynamic Memory Controller)
> 
> Following list specifies the detailed relation between memory bus clock and
> sub-IPs in INT (Internal) block:
> - ACLK100 clock : PERIL
> - ACLK160 clock : LCD0
> - ACLK200 clock : FSYS
> - ACLK266 clock : ISP
> - GDL/GDR clock : leftbus/rightbus
> - SCLK_MFC clock : MFC
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>



> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 125 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 125 insertions(+)
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
