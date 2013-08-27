Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3H0DHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:07:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24802 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3H0DHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:07:34 -0400
X-AuditID: cbfee68e-b7f756d000004512-88-521c17f51096
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mateusz Krawczuk'" <m.krawczuk@partner.samsung.com>,
        "'Sylwester Nawrocki'" <sylvester.nawrocki@gmail.com>
Cc: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        tomasz.figa@gmail.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377517114-20222-4-git-send-email-m.krawczuk@partner.samsung.com>
 <1445676.NMCyFEC5q4@amdc1032> <521BA070.2000800@gmail.com>
In-reply-to: <521BA070.2000800@gmail.com>
Subject: Re: [PATCH RFC 3/5] ARM: samsung: add clock setup for FIMC and FIMD
Date: Tue, 27 Aug 2013 12:07:32 +0900
Message-id: <000201cea2d2$92a43530$b7ec9f90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ii24AD9H1qmZ2TNC6yKy7P/sttQARtQNw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSe0iTURjGO/sum9boyzSPkglWSt7vnlArCOILksooIipb60MlnWNTC4qS
	lBSdOlPSlle8JGspakGKmFNT8j4tXZrSVdN51yxNs81Pwn/773fOeZ73eTi8PMzkE2HJCxVF
	MhKRIMyGNMbb/oy4Ov0w3x3o2j6No4qscgLlNXUSaCI5AUe9BT0ESs5/R6KOexNcVPmlj0C9
	Ndkkyuqq46DBXj7SlFmjNlUrhnQpjTgq7tdw0De5hkTyzGc4aiyt56CysUw9TcQTaFx9H0e5
	89UcVJ6l01P8GIGas4oAUtasgCMWtCpXBei4WBlJ58+/5dK6dDmgqxVDXHr86SOC/tBXS9JV
	RXdp9VQth055rgR00twAQc9X7qErcs6e4l8w9rvGhIVGMxKXQ1eMQ+qXlnDxInFT/UZBxgAt
	ngiMeJDyhLLZQozlXbB7uJxMBMY8E6oEwIcdM/9EqQ+WCfYhE8Dmyd+APSwDGJtcsG4nKVu4
	sNDINbApJYKdj9sxgwij1nCY35C9MbcbwJ85Q3oVj2dEHYCzsmMGw07qBKwYnSQNjFP7Ycmr
	WMLAfMof5iQNcVjeAX+lD69Xwih7WF7dwmHZGlapJjHDSEjZwc+rTmwHd1jXOkewElNY931q
	vTSknhhBzcw4YLMouJjegLNeK1hZv/EVFlBdqsXlACo2JSs2JSs2JSs2ReQDXAnMGLFQLL0a
	LHF3lgrCpVGiYGdhRHglYNcr5SV4X+/bAIT6+DTM0kwYoV8/UWSQm4e3O/Ly9PJw9zno/X/X
	NuZ82zjf0yZUsCCSuc4wYkYSJIkKY6QNgMMzsowBUXEZL47dtvm69VytaoB/K1UcIGb2+Wms
	ekd6+s1mHEKlKE/omBp1PuJigv30mQBtnNa/1Ke4ulDQlLa0Emwduq3l6PTgJee94jWXG6uO
	nvwm2es7A5dn1SmzJ9vtdAsCqtBRS2zvxqnRyY+6fnmhw/EqsWz5sNJqy0SXPDA6wwaXhgjc
	7DGJVPAXeF5U/nQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsVy+t9jQd0v4jJBBs9brC02zljPajH/yDlW
	ize9HSwWlxdeYrXoXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NaXFwnb3F6zSlmi9d9
	h1ksll6/yGTxdMJFNosJ09eyWBxecYDJYt3L6UDWm3ZWi1cH21gs5n3eyWSxfsZrIKv9JavF
	sRlLGC1W7frD6CDpsWbeGkaPluYeNo8Fn6+we7yePIHRY+esu+wer1bPZPW4c20Pm8fmJfUe
	B9/tYfLo27KK0aP70y1Wj8+b5Dw2zg0N4I1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAYaCkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwjjHjwM+fLAXfWCsOnpzF1sB4g6WLkZNDQsBEon/SL1YIW0ziwr31bF2MXBxCAtMZ
	JY69/c0I4fxilGjuXcgMUsUmoCbx5cthdhBbRCBP4tzsM8wgRcwC/1kkFhyaA9V+gVHi+9y7
	QFUcHJwCmhIfe9xAGoQFfCQ2Pn/LBmKzCKhKLNvfDLaaV8BWYm73XSYIW1Dix+R7YOcxC2hJ
	rN95nAnClpfYvOYtM8hICQF1iUd/dSFuMJLYd+oTK0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqF
	pGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODU+ExqB+PKBotDjAIcjEo8vB1N0kFC
	rIllxZW5hxglOJiVRHi57gCFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YtvNK4g2NTcyM
	LI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTFm8foEIa21XR9ncloKfPPM
	WPeg6v2Ghn6lW5knex7a+jdOP7pY7QvzjZOpXyYxnOjemLIgOts0fd9NntZZ1ilTXu/Yznw8
	3NTo4BwjDsG2ktM/FzN82Xw8NO6IN19g2Zon88+J5nRsWsK5QOb8L/YlEnar7h66yJNdZrCc
	oWj2g6vGDcuYg+uUWIozEg21mIuKEwF+xhaH0QMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 27, 2013 3:38 AM, Sylwester Nawrocki wrote:
> On 08/26/2013 06:19 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Monday, August 26, 2013 01:38:32 PM Mateusz Krawczuk wrote:
> >> This patch adds code that sets correct parents and rates for clocks
> >> used by FIMC and FIMD on Goni board.
> 
> This patch is supposed to be a workaround to make the display and camera
> subsystem working even without properly configured parent clocks in the
> boot-loader, right ? And as such it doesn't really belong to this series
> and has been written primarily for the clocks testing purposes ?
> I think it can be dropped in the next iteration of this series.
> 

Agreed. :-)
This patch can be dropped next.

Best regards,
Jingoo Han

