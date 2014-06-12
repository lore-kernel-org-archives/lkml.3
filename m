Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaFLAG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:06:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34255 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaFLAG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:06:26 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-cd-5398eefb3290
Date: Thu, 12 Jun 2014 00:06:19 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: Re: mips: math-emu: Fix compilation error ieee754.c
To: Ralf Baechle <ralf@linux-mips.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140612000533665@eunb.song
Msgkey: 20140612000533665@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140612000533665@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <10240088.548381402531578961.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsVy+t8zXd3f72YEG3x7ZmpxedccNgdGj8+b
	5AIYoxoYbRKLkjMyy1IVUvOS81My89JtlUJD3HQtlBQy8otLbJWijQyM9YxMTfSMTMz1LA1i
	rYxMlRTyEnNTbZUqdKF6lRSKkguAanMri4EG5KTqQcX1ilPzUhyy8ktBLtErTswtLs1L10vO
	z1VSKEvMKQUaoaSfMJUx4/WxnYwFFRWzv8xia2As6GLk5BASUJFo+f+dEcSWEDCRuP74CguE
	LSZx4d56ti5GLqCaZYwS99Y9gyta+/YvI0RiDqPEl8eX2EESLAKqEquXbWYGsdkEtCV+HLgK
	ZgsLOEhcvnuYFcQWEdCQ2HB3G1g9s0CNxLer+1ghrpCXmHz6MlicV0BQ4uTMJ1BXKEk0Nx1h
	hIgrS6y4DlEjISAhMWv6BVYIm1diRvtTqHo5iWlf1zBD2NIS52dtYIT5ZvH3x1Bxfoljt3cw
	dTFygPU+uR8MM2b35i9sELaAxNQzBxkhStQldjXmQIT5JNYsfAu1SVDi9LVuZpjW+1vmMkF8
	pSgxpfsh1IdaEl9+7GND9RUHkO0ksfeJ2QRG5VlIMrOQdM9C0o2sZgEjyypG0dSC5ILipPQi
	U+SY3sQISYATdzDeP2B9iHE/IzBGJjJLiSbnA1NoXkm8obGZkYWpiamxkbmlGYXCJqYWFiZG
	VBFWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx0KqYq+xAc4B144GXz7a9P3lo
	3+JL2tMYz4oI3l9mvPG03/fdM1aHLHD/zLxx43pDxkdFyntnWK3+lnJw/cHAqsKk2XziL5W+
	p5yLfbl4f+F+x3qZuzknPK6UrWt7pmvzfmW08KZqjyKd5mnTJIt+JWp9CQ3tv9H+VWL3q+Mb
	tkXseTMhSZxVS4mlOCPRUIu5qDgRAOnxP0zzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tPt3f72YEGzx6pm9xedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfRMDGKtDA0MjEyBqhIy
	Ml4f28lYUFEx+8sstgbGgi5GTg4hARWJlv/fGUFsCQETibVv/0LZYhIX7q1n62LkAqqZwyjx
	5fEldpAEi4CqxOplm5lBbDYBbYkfB66C2cICDhKX7x5mBbFFBDQkNtzdBlbPLFAj8e3qPlaI
	ZfISk09fBovzCghKnJz5hAVimZJEc9MRRoi4ssSK6xA1EgISErOmX2CFsHklZrQ/haqXk5j2
	dQ0zhC0tcX7WBrijF39/DBXnlzh2ewdTFyMHWO+T+8EwY3Zv/sIGYQtITD1zkBGiRF1iV2MO
	RJhPYs3Ct1CbBCVOX+tmhmm9v2UuE8RXihJTuh9Cfagl8eXHPjZUX3EA2U4Se5+YTWCUm4Uk
	MwtJ9ywk3chqFjCyrGIUTS1ILihOSq8w1itOzC0uzUvXS87P3cQITk3PFu9g/H/e+hCjAAej
	Eg8vQ+2MYCHWxLLiytxDjBIczEoivI7ngUK8KYmVValF+fFFpTmpxYcYk4HRN5FZSjQ5H5g2
	80riDY0NjA0NLc0NTA2NLEgTVhLnjb+VFCQkkJ5YkpqdmlqQWgSzhYmDU6qBMV6dvUBuysn3
	cx8z2vv/XcnLsYC9WGSn7dn/tb6ax9wmfo9Obp3yZI2L1sFsASHOFovA/ZyHbZ0YE+/tL7i5
	JnHzEa8Kk8JImaMNG0r/pG7TNpH5xP9zWdevpeWHa97d37SKz6zpu8f3HyINB/TOGTFNnLKy
	eSev8raiJUFas68ceWF6MNlptRJLcUaioRZzUXEiADeoAeeRAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5C06XYT002058



> What gcc version are you using?

>  Ralf

I am using gcc 4.4.1. 
Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
