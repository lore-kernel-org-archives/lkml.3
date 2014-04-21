Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaDUJ7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:59:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20796 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaDUJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:58:54 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-5b-5354ebddbd44
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Marek Vasut'" <marex@denx.de>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "'Rob Herring'" <robherring2@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
 <20140416165724.GG7802@e106497-lin.cambridge.arm.com>
 <16730530.rJ9T0MsYmt@wuerfel> <000001cf5d04$982a6000$c87f2000$%han@samsung.com>
In-reply-to: <000001cf5d04$982a6000$c87f2000$%han@samsung.com>
Subject: Re: [RFC PATCH 1/2] PCI: designware: Add ARM64 PCI support
Date: Mon, 21 Apr 2014 18:58:52 +0900
Message-id: <000501cf5d48$4cf707c0$e6e51740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZoV9F7nOBrq3kQta8LMyyVpoKWwDYDJxgABEzhHA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t8zY927r0OCDVoms1v8nXSM3eLquWOM
	FkuaMixeHtK0uLzwEqvF9xumFr0LrrJZXHjaw2bx/tAzZotNj6+xWlzeNYfN4uy842wWB5a2
	s1i8aWtktNg49RejRfslZYvHs4Qtvn/7xuYg5LFm3hpGj9+/JjF6zJt1gsXj3+F+Jo+ds+6y
	eyzYVOqxeUm9x+1/j5k9vu/oZfTo27KK0ePpj73MHsdvbGfy+LxJLoA3issmJTUnsyy1SN8u
	gSvjwYHogulCFavnJzUwLubrYuTkkBAwkVj0cAU7hC0mceHeerYuRi4OIYFljBLbZ/WwwxQd
	7F3NBJGYzihx5VYvlPObUWLy2xcsIFVsAmoSX74cBusQEfCQ+PFgOTtIEbPAZRaJK8v+ssB1
	HLk4lwmkilPATmJb/xWwDmEBZ4kTz1vB4iwCqhJ/e3aATeUVsJWY23WJEcIWlPgx+R5YnFlA
	S2L9zuNMELa8xOY1b5m7GDmAblWXePRXF+IIK4lNk66zQ5SISOx78Y4R5AYJgSccEmtOt7NA
	7BKQ+Db5EAtEr6zEpgPMEC9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJRe
	ZKRXnJhbXJqXrpecn7uJEZJu+nYw3jxgfYgxGWj9RGYp0eR8YLrKK4k3NDYzsjA1MTU2Mrc0
	I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MsuHNvCqf36+MPXU5dFuwVqZE
	/iHOuX8Db1wW0ZKztT99tEMgKfjg9dKz3RbPHKYuuXSOe+7EHI7DuzcHF5xaKeHRE5J+YF7c
	Yxld+QIOTtXnS08nJ6xUTMlPiflmmSZwkCOy+Vkaj0H2vU98N+Y9rlIKytab8ml9zauGbdzy
	+4tbQ9hd3ZiUWIozEg21mIuKEwGCXzgsTQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsVy+t9jQd27r0OCDW6YWvyddIzd4uq5Y4wW
	S5oyLF4e0rS4vPASq8V3oFTvgqtsFhee9rBZvD/0jNli0+NrrBaXd81hszg77zibxYGl7SwW
	b9oaGS02Tv3FaNF+Sdni8Sxhi+/fvrE5CHmsmbeG0eP3r0mMHvNmnWDx+He4n8lj56y77B4L
	NpV6bF5S73H732Nmj+87ehk9+rasYvR4+mMvs8fxG9uZPD5vkgvgjWpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBek9JoSwxpxQoFJBYXKykb4dp
	QmiIm64FTGOErm9IEFyPkQEaSFjHmPHgQHTBdKGK1fOTGhgX83UxcnJICJhIHOxdzQRhi0lc
	uLeerYuRi0NIYDqjxJVbvUwQzm9GiclvX7CAVLEJqEl8+XKYHcQWEfCQ+PFgOTtIEbPAZRaJ
	K8v+ssB1HLk4F2wup4CdxLb+K2AdwgLOEieet4LFWQRUJf727ACbyitgKzG36xIjhC0o8WPy
	PbA4s4CWxPqdx5kgbHmJzWveMncxcgDdqi7x6K8uxBFWEpsmXWeHKBGR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnMqeSe1gXNlgcYhRgINR
	iYd3RklIsBBrYllxZe4hRgkOZiUR3oj1QCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6bZ
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgrAy9+//8tfAt
	SkW8leJHp8VHfbwRNrXriyOvXfDFu6qKjgHi3yd80JyfFZIkFfK44M6XlEbL/VdV5s67HVq9
	t6/M9/zJFZPvnLfY0VgYYB/5IOPxLSenDIt/LLEtTsu+RFlPTv3nfOGvs+zvxd6Tw9Z2vd6j
	wvZvj8zZH2cv3Nuh83qCbcLWFUosxRmJhlrMRcWJAAKgssSpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 10:54 AM, Jingoo Han wrote:
> On Thursday, April 17, 2014 3:26 AM, Arnd Bergmann wrote:
> > On Wednesday 16 April 2014 17:57:24 Liviu Dudau wrote:
> > > Jingoo,
> > >
> > > Thanks for taking a stab at trying to convert a host bridge
> > > driver to use the new generic host bridge code.
> > >
> > > I do however have concerns on the direction you took. You have split
> > > your driver in two, depending on whether it was CONFIG_ARM or CONFIG_ARM64,
> > > even if (with my series) it should be no reason why the host bridge
> > > driver should not work on other architectures as well once they are
> > > converted.
> >
> > Right.
> >
> > > Also, some of the functions that you use have identical names but different
> > > signatures depending on what arch you have selected. This is really bad
> > > in my books!

[.....]

> > > What about creating functions that use my series directly if CONFIG_ARM64 is
> > > defined (or any CONFIG_ you want to create for your driver that you select
> > > from CONFIG_ARM64) and otherwise implement the CONFIG_ARM version? That
> > > way your driver will call only one API without any #ifdef and when arm code
> > > gets converted you drop your adaptation functions. Or (better yet), have a
> > > stab at converting bios32 (Rob Herring has already provided some hints on
> > > how to do it for arch/arm).
> 
> To: Liviu Dudau
> 
> Sorry, but I will not implement this.
> At first, you had to think the compatibility with ARM32 PCIe.
> Why do you want other engineers to take this load?

(+cc Rob Herring)

Um, I am looking at Rob Herring's patchset for Versatile PCI. [1]
Then, do you mean the following?

1. Add Rob Herring's patch converting bios32. [2]
2. Reference Rob Herring's patch in order to know how to
    handle "of_create_pci_host_bridge()" directly in ARM32. [3]
3. Use of_create_pci_host_bridge() for the designware PCIe
    driver in ARM32.
4. Also, use of_create_pci_host_bridge() for the designware PCIe
    driver in "ARM64".


[1] http://www.spinics.net/lists/linux-pci/msg30084.html
[2] http://www.spinics.net/lists/linux-pci/msg30083.html
[3] http://www.spinics.net/lists/linux-pci/msg30086.html

Best regards,
Jingoo Han

> 
> >
> > That would of course be best.
> >

[.....]

