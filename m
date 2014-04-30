Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbaD3Glr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:41:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15404 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaD3Glo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:41:44 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-ff-53609b250e97
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000401cf6367$cc461500$64d23f00$@samsung.com>
 <20140429144759.GL17007@arm.com>
In-reply-to: <20140429144759.GL17007@arm.com>
Subject: Re: [PATCH v4 4/7] arm64: Add a description on 48-bit address space
 with 4KB pages
Date: Wed, 30 Apr 2014 15:41:40 +0900
Message-id: <008e01cf643f$3e67eff0$bb37cfd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQFBGkz5dCrKcMPvFcAYB1mhgrfVFQGgwAMmnDlBcEA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zvq7q7IRggwVrBCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	3aOb7AW/+Sv6Gt6yNjA+5uli5OSQEDCRWHLuLBOELSZx4d56ti5GLg4hgWWMEi877rF2MXKA
	Ff09zA4Rn84o8f7mV0YI5w+jxJapL1lButkENCUe3e1hB7FFBPQlFl+5wQpSxCzQwSyx9Oky
	RpCEkECMxPuze5hBpnIK6Eo8eKoMEhYWiJVoaTwK1ssioCpxcu5eZhCbV8BS4sO+/UwQtqDE
	j8n3WEBsZgEtifU7jzNB2PISm9e8ZYb4QEFix9nXjBBxEYl9L94xQtxjJTHzXSsLyD0SAks5
	JPYvXckGsUxA4tvkQywQX8pKbDoANUdS4uCKGywTGCVmIVk9C8nqWUhWz0KybgEjyypG0dSC
	5ILipPQiI73ixNzi0rx0veT83E2MkBTQt4Px5gHrQ4zJQOsnMkuJJucDU0heSbyhsZmRhamJ
	qbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCU8zlSMXvuvdvcD+wu
	LHhnWbNBfP4MW4mY285eB2x39yY7PZx3sYTv2L0DCzUnb1XbM1PY9erx+0t+/rhpWu0sIKM1
	g+P3LJZIL13/GoWEe6X/+jbuYXdzdfpd0vJ58/5VhXWLd6i53J6eWfDws/1hQ12rzARRF2lG
	GYNVDQtbFpcervvnfcldiaU4I9FQi7moOBEATnDz9RcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQV3V2QnBBs86uC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxrtHN9kLfvNX9DW8ZW1gfMzTxcjBISFgIvH3MHsXIyeQ
	KSZx4d56ti5GLg4hgemMEu9vfmWEcP4wSmyZ+pIVpIpNQFPi0d0esA4RAX2JxVdusIIUMQt0
	MEssfbqMESQhJBAj8f7sHmaQDZwCuhIPniqDhIUFYiVaGo+C9bIIqEqcnLuXGcTmFbCU+LBv
	PxOELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSEuVZDYcfY1I0RcRGLfi3eMEPdYScx818oy
	gVFoFpJRs5CMmoVk1Cwk7QsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeYZ9I7GFc1
	WBxiFOBgVOLhFdgaHyzEmlhWXJl7iFGCg1lJhDejIyFYiDclsbIqtSg/vqg0J7X4EGMy0KcT
	maVEk/OByS+vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgb
	Qs/9CHo86dG+AztPVvR6dxUd/5v61b2N55fz/VUSW1m8Vqu+t7gi/mO+RMux1G7VzT4rTi5Z
	YGVt9SZ+asH8VT1P79/u7owMDVaL37zL89e5NYc3fNV6MtND6IL1vB2b5ipKcBd/cw98ey1u
	/8ujTG7qKtcSJx+YrvL785rzEl6V83r+PPdqVmIpzkg01GIuKk4EAI5OJ5V0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 11:48 PM, Catalin Marinas wrote:
> On Tue, Apr 29, 2014 at 05:59:27AM +0100, Jungseok Lee wrote:
> > --- a/Documentation/arm64/memory.txt
> > +++ b/Documentation/arm64/memory.txt
> > @@ -8,10 +8,11 @@ This document describes the virtual memory layout
> > used by the AArch64  Linux kernel. The architecture allows up to 4
> > levels of translation  tables with a 4KB page size and up to 3 levels with a 64KB page size.
> >
> > -AArch64 Linux uses 3 levels of translation tables with the 4KB page
> > -configuration, allowing 39-bit (512GB) virtual addresses for both
> > user -and kernel. With 64KB pages, only 2 levels of translation tables
> > are -used but the memory layout is the same.
> > +AArch64 Linux uses 3 levels and 4 levels of translation tables with
> > +the 4KB page configuration, allowing 39-bit (512GB) and 48-bit
> > +(256TB) virtual addresses, respectively, for both user and kernel.
> > +With 64KB pages, only 2 levels of translation tables are used but the
> > +memory layout is the same.
> 
> Any reason why we couldn't use 48-bit address space with 64K pages (implying 3 levels)?

No technical reason.
Since 64K+3levels is not implemented in this set, I didn't add it.

Should 64K+3levels be prepared in this patchset?

> > -AArch64 Linux memory layout with 64KB pages:
> > +AArch64 Linux memory layout with 4KB pages + 4 levels:
> > +
> > +Start			End			Size		Use
> > +-----------------------------------------------------------------------
> > +0000000000000000	0000ffffffffffff	 256TB		user
> > +
> > +ffff000000000000	ffff7bfffffeffff	~124TB		vmalloc
> 
> BTW, maybe as a separate patch we should change the "end" to be exclusive. It becomes harder to modify
> (I've been through this a few times already ;)) and even follow the changes.

Does "exclusive" mean that 0000ffffffffffff is changed to 0001000000000000?
Or Does it mean that "End" column is dropped?

If you are okay, I will make it as a separate patch.

Best Regards
Jungseok Lee

