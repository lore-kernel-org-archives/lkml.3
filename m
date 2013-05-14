Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3ENMgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:36:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21433 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3ENMgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:36:44 -0400
X-AuditID: cbfee68f-b7f436d000000f81-8e-51922fdaf69c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
Cc: robin.randhawa@arm.com, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-pm@vger.kernel.org, patches@linaro.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
References: <cover.1365079581.git.viresh.kumar@linaro.org>
 <5176A807.2090005@samsung.com>
 <CAKohpomV9-JEbuHWdmp6N+bKYt+83hXXcqg4aKXSY1a5zwpW9Q@mail.gmail.com>
 <105283277.osOpfTKkgk@vostro.rjw.lan>
 <CAKohponkFB7ND38jv5oGnQLx8cq0b=uHTCmL3EERe6P54ijYhw@mail.gmail.com>
In-reply-to: <CAKohponkFB7ND38jv5oGnQLx8cq0b=uHTCmL3EERe6P54ijYhw@mail.gmail.com>
Subject: RE: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to
 drivers/cpufreq
Date: Tue, 14 May 2013 21:36:42 +0900
Message-id: <093901ce509f$afe92f40$0fbb8dc0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5PxyGIq7zsLFFjR4KpAQS0H8YeIQA2DKwg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zQ91b+pMCDTbdE7J43T2b1WLSugNM
	Fht7PrNbPG36wW7x/tAzZotNj6+xWlzeNYfN4nPvEUaLGef3MVkcWNrOYjHl8BcWi/6FvUwW
	nw/vYrdYe/cpUO9XDwd+jzXz1jB6/F31gtnjzrU9bB6bl9R73P73mNnj0eIWRo/Pm+QC2KO4
	bFJSczLLUov07RK4Mq5fbmYsuMJSsWjSEdYGxtPMXYwcHBICJhKnrtd3MXICmWISF+6tZ+ti
	5OIQEljGKPFu2xwmiISJxLvDvcwQiemMEvtmT2AHSQgJ/GWUWHFKGsRmE9CQOPz+GVhcRCBY
	4uH+VrBJzAI/mSRW/DkD1T2RSeLyumPMIFWcQFW7WhcygZwhLBAqsfuMKUiYRUBVYtLsC6wg
	Nq+ArcT53lvMELagxI/J91hAbGYBLYn1O48zQdjyEpvXvIX6Rl3i0V9diBuMJDatfskKUSIi
	se/FO0aQEyQEtnBIbPn+hxlil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkOTQv4Px7gHrQ4zJQOsnMkuJJucD
	k0teSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjr
	ZXjU7zXn1DGmvL0rfev63dQs2QTH0JaYxpUxh3leL2DcOPFm4+aTmkk/2zbsLnI4v9s7q0Cs
	f96tg1W/cm9tORg0da7nwZzvDxcXP0y7MX1e60X9qGM2Yr0tSTfuuqZ8ZLjk/vr7ugss/fL/
	zuzrsvC+1PhI2mihw/y1G69yh7xYv+N63vqpSizFGYmGWsxFxYkAz+xGsiQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQd1b+pMCDdZv4bV43T2b1WLSugNM
	Fht7PrNbPG36wW7x/tAzZotNj6+xWlzeNYfN4nPvEUaLGef3MVkcWNrOYjHl8BcWi/6FvUwW
	nw/vYrdYe/cpUO9XDwd+jzXz1jB6/F31gtnjzrU9bB6bl9R73P73mNnj0eIWRo/Pm+QC2KMa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgO5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZcv9zMWHCFpWLRpCOsDYynmbsY
	OTkkBEwk3h3uhbLFJC7cW8/WxcjFISQwnVFi3+wJ7CAJIYG/jBIrTkmD2GwCGhKH3z8Di4sI
	BEs83N8K1sAs8JNJYsWfM8wQ3ROZJC6vOwY2lhOoalfrQqYuRg4OYYFQid1nTEHCLAKqEpNm
	X2AFsXkFbCXO995ihrAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zyBgJAXWJR391IW4wkti0
	+iUrRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4OTzTGoH48oGi0OMAhyMSjy8DXUTA4VYE8uKK3MPMUpwMCuJ8F7mnhQoxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnAxJhXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTU
	gtQimC1MHJxSDYydjhbp0/IU9/dMmGP854HSw5AgttKjIuXib9U1nTmO2AarrImzeZV42VJm
	Z5LOYg8vdd3zkisvh28r+SDd4VI8oS+wqLtC1kf4yoKTH99/e9x28hx/qt7LlhOsVeGt7Dwr
	GLMEzzvKn3i7WfT9iW/K89x1Ty/JEV+h8kqf/4Ibf53D8jMah5VYijMSDbWYi4oTAWKt7seC	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar wrote:
> 
> On 13 May 2013 16:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > That doesn't matter I suppose.  I can take it, but please rebase it on
> top
> > of current linux-next.
> 
> I have already done that (attached). But i wasn't sure what Kukjin wants
> as
> he may report conflicts again and i will ask the same question for 3.12 :)
> 
Since this missed last time, this would be sent to upstream via samsung tree
again. It means the conflicts should be handled by myself.

Rafael, if you don't mind, let me take this into Samsung tree for v3.11.

- Kukjin

