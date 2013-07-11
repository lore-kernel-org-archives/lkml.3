Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3GKBhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:37:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65404 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3GKBg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:36:58 -0400
X-AuditID: cbfee68e-b7f276d000002279-5d-51de0c38d811
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
 <51DD695C.6060209@ti.com>
In-reply-to: <51DD695C.6060209@ti.com>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Thu, 11 Jul 2013 10:36:55 +0900
Message-id: <000b01ce7dd7$20be5bf0$623b13d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQII16kcxw44AVHNORO1PoktmeAs2wGxCgTlmNxzPeA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zga4Fz71Ag/P3TC3+TjrGbrGkKcPi
	5SFNi8sLL7Fa9C64ymZx4WkPm8XlXXPYLM7OO85mMeP8PiaLjVN/MVq0X1K2aDz6gNWi9ckD
	Rgdej9+/JjF6LNhU6vF94Xx2j74tqxg9nv7Yy+xx/MZ2Jo/Pm+QC2KO4bFJSczLLUov07RK4
	Ml5O72Mv6GCr6Lq2hKmB8QZLFyMnh4SAicT3KUvYIWwxiQv31rOB2EICyxglLjzPgqk5Of8K
	UD0XUHw6o8SJY1/YIJxfjBJ7m6Ywg1SxCahJfPlyGGySiICOxMLT65lBipgF5jJLHO5rZYEY
	GyrR82AXK4jNCdTQ9fYNWFxYIE5iwqvnQM0cHCwCqhLdO9RAwrwClhKnj+xghbAFJX5MvgdW
	ziygJbF+53EmCFteYvOat8wQlypI7Dj7mhHiBiuJHcdOsELUiEjse/GOEeQeCYG5HBJzDh8B
	e5NFQEDi2+RDLCB7JQRkJTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJB
	cVJ6kZFecWJucWleul5yfu4mRkga6NvBePOA9SHGZKD1E5mlRJPzgWkkryTe0NjMyMLUxNTY
	yNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MPOwPK+27jyf9MNrpVHKl
	tuyQOP+TGb5Pni8p7uD9EC54NanLsX3/rtAl7Y/e3Nm9nT+scN1rgZD1G0O9thhPbzBpOp50
	nHlLp6nF7HMu8xjMQ4olvkXZ7p+kddJ4fUXviuaJTh8iIzceSrjttsbAVa9fYrmqedah876r
	j3mEF0z6KhK7eDKfEktxRqKhFnNRcSIALl1T3hkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jQV0LnnuBBnP3GFj8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3iwtMeNovLu+awWZydd5zNYsb5fUwWG6f+YrRov6Rs0Xj0AatF65MH
	jA68Hr9/TWL0WLCp1OP7wvnsHn1bVjF6PP2xl9nj+I3tTB6fN8kFsEc1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsY8x4Ob2PvaCDraLr2hKmBsYbLF2MnBwSAiYSJ+dfgbLF
	JC7cW8/WxcjFISQwnVHixLEvUM4vRom9TVOYQarYBNQkvnw5zA5iiwjoSCw8vZ4ZpIhZYC6z
	xOG+VrBRQgKhEj0PdrGC2JxADV1v34DFhQXiJCa8eg7UzMHBIqAq0b1DDSTMK2ApcfrIDlYI
	W1Dix+R7YOXMAloS63ceZ4Kw5SU2r3nLDHGpgsSOs68ZIW6wkthx7AQrRI2IxL4X7xgnMArN
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4DTzTGoH48oGi0OM
	AhyMSjy8DfF3A4VYE8uKK3MPMUpwMCuJ8J6cAhTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHk
	fGAKzCuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxvPsMm/c
	TUTezA+tUcitOv3gsf7hE1J6OoVlMg8qNh+Sf+4St2FvlM5Cg6XPVMKWnuPofcsqGuHl+foh
	w23WQ3enrG8rLQxjmC82a6OUzkeZ0+t3iYotvHllO89f/5dHb111Mvt3K1H7fJ3w0yuPQuwl
	EwuWq38vMVAqXqnIdvZ1iVTq73nZ+UosxRmJhlrMRcWJABwuXgl3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 10, 2013 11:02 PM, Kishon Vijay Abraham I:
> On Friday 05 July 2013 01:59 PM, Jingoo Han wrote:
> > Exynos PCIe IP consists of Synopsys specific part and Exynos
> > specific part. Only core block is a Synopsys designware part;
> > other parts are Exynos specific.
> > Also, the Synopsys designware part can be shared with other
> > platforms; thus, it can be split two parts such as Synopsys
> > designware part and Exynos specific part.
> 
> Thanks for doing that :-)
> 
> I'll be using the synopsys specific part as Jacinto6 also uses the same pcie
> core. Once I start implementing, I'll have some queries and comments ;-)

Hi Kishon,

OK, I see.
I will send v2 patch.
Also, I will be CC'ing you. :)


Best regards,
Jingoo Han


