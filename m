Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FXCwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 22:52:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25536 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3FXCwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 22:52:18 -0400
X-AuditID: cbfee691-b7fef6d000002d62-8a-51c7b45b105d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
References: <003901ce6e50$03d039a0$0b70ace0$@samsung.com>
 <201306211030.47440.arnd@arndb.de>
 <20130621141144.GP31667@titan.lakedaemon.net>
 <201306211614.49434.arnd@arndb.de>
In-reply-to: <201306211614.49434.arnd@arndb.de>
Subject: Re: [PATCH V10 0/4] PCIe support for Samsung Exynos5440 SoC
Date: Mon, 24 Jun 2013 11:52:10 +0900
Message-id: <007201ce7085$d2c4fed0$784efc70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGUdTHW8S3Ki6WsdmOmookP+R5aHQIq7FD7AbNMYc4DNw4hX5l/djIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSfyyUcRzH973nueeOpj1+9k2jplXLQrjTV6yJVk+iztb6Q0nXeYbFsbtj
	/Rei1m3XcInRirrVkevyICI613KzyI/DZIYmLVRbCF2hu3v64/7tv9f3+35/P+/3vvvwMbdh
	rjc/XaqgZVJxhh/hjL/b+BwScL7JlHBwpd4TXd9s4aL10m4e0hSkoTnjfmSo+shF870NBMrX
	mHFkrhniotUxIVJVjxCImRnlInPbPQL13TcRqKK/k4MayiwA3RzajbQFzQA9GnyCIX3FAo7a
	azU46q7QADQ7XcCJ8qLq79cD6relFFC374wQ1CdmEFDVTA6VZ+jHqYnRVwTVqLlG9VfUAGq1
	VWV1NdUB6tfcAWp2rQOjlhhf0dZE58gUOiM9l5YFHbnknNbT9xPLfrHlqrZRheeBCb4S8PmQ
	FMARXa4SOFnRCw5M6gklcOa7kY8BXB0ewVlBAJ/dmMdYoRzAtrX3PPZgAbBYu4jZXAS5Fy4v
	v+HZ2IOk4YOiDfsojKwiYOd4l11wIxsBLK9xt7ETGQTnjUb7Y3fyGPzR+xXYGCf3wCXmNcfG
	LmQ4fGhiAMuucE09aa+Ekf5Q/9LEYXknbKz/hrFVd8HWvgXAljgOO3SFPNbjATu/fAe2QpBU
	O8H1gTqCDSPhitqIs3/hAxnDvznbYZd2DC8GsNIhutIhutIhutIhohrgdcCTzpZkyy+nyoSB
	cnGmPEeaGijJymQAu1ElrWDKEGEEEmt8CebtKcmybpxUkRwcGhaChAJhaMih8LD/u/bb5rKv
	MCLBjUwVK+grNJ1Ny5JlORm03Ag4fCfvPBDanSg+3dOSpPeatiguinaErigP81Qnnn6I1Y6e
	S9QL3tbGanzEvbq4zFtnhWei1ZFhovao8fimwIUQTbBIdze5r2jKVWkOymdSYmZo31bTBd2f
	opiTVa6i5hWD1EV+dDGsPT1+MiKuLWDNbPGKKss/VT7Ha38e3VWUtEmkNfvh8jRxsD8mk4v/
	AvUiLmxnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsVy+t9jQd3oLccDDVZP5LNo/r+d1eLvpGPs
	FkuaMixeHtK0ODD7IavFqzMb2Swal1xmsbi88BKrxfcbpha9C66yWWx6fI3V4vKuOWwWZ+cd
	Z7OYcX4fk8XGqb8YLdovKVusaNrKaLH44nJmi/UzXrNY7F65hMXi2IwljBZPHzQxOYh5rJm3
	htHj969JjB59U66yeTzZdJHRY8GmUo+GA+dZPO5c28PmsXlJvcf5GQsZPb7v6AWq2rKK0ePn
	Sx2Ppz/2Mnt83iQXwBfVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/S4kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj5Nmv
	zAXbuCtWbO5laWC8w9HFyMkhIWAisa7tFTOELSZx4d56ti5GLg4hgemMErt+nGOHcH4xSkxY
	8Qmsik1ATeLLl8PsILaIQKrE/NZ/YB3MArPZJPbdOgiWEBLYzCgxfaEwiM0poC/x6tAhsGZh
	AReJj2feMILYLAKqEp837WcCsXkFLCUWHd/ECGELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVuo
	UxUkdpx9zQhxhJvE3rUt7BA1IhL7XrxjnMAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPS
	c430ihNzi0vz0vWS83M3MYJT4DPpHYyrGiwOMQpwMCrx8C4wPx4oxJpYVlyZe4hRgoNZSYTX
	dzFQiDclsbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OB6TmvJN7Q2MTMyNLIzMLIxNycNGElcd6D
	rdaBQgLpiSWp2ampBalFMFuYODilGhjZXJpLzdLONXWbuvJkFP7cGCkb2JfIHNP5esahplWu
	PcLFDitfLUs5/uRUoh5v8cN5bW2acxV7mNVqS98cfJN48cDdd+XrmjzsOQ39yvOf//tw/be7
	3vWTbZlPJ9ycu/bSlRgF6bVxoZd+L+VlO+P+qvfHY9PnibNzDoW26RfHCr2/rtOe91aJpTgj
	0VCLuag4EQB8s5SYxQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 11:15 PM, Arnd Bergmann wrote:
> On Friday 21 June 2013, Jason Cooper wrote:
> > On Fri, Jun 21, 2013 at 10:30:47AM +0200, Arnd Bergmann wrote:
> > > On Friday 21 June 2013, Thomas Petazzoni wrote:
> > > > I am by far not an expert on how to solve merge strategies and so on,
> > > > but to avoid conflicts at Linus's level while merging the arm-soc and
> > > > pci trees, it would be better if this Samsung PCIe driver could go
> > > > through arm-soc (with Bjorn ACK, of course), so that Arnd/Olof can
> > > > make sure the ordering is correct with regard to the of/pci changes and
> > > > the mvebu/pci driver.

Yes, right.
That is the reason why I based on 'linu-next' tree,
instead of 'PCI' -next branch.


Bjorn Helgaas,
Could you give your ACK?
Thank you.


Best regards,
Jingoo Han

> > >
> > > Yes, good point.
> > >
> > > The alternative would be that Bjorn also takes the PCI branch dependencies
> > > that are already in arm-soc into his tree. Either way works, but I agree
> > > that what you suggest would be simpler.
> >
> > Yes, that is why we did it this way.  It was my understanding based on
> > previous comments by yourself and LinusW that you both had patches
> > depending on (now called) mvebu/of_pci.  So we got it into arm-soc
> > early so those branches could depend on it.
> 
> Right. I wasn't paying enough attention for the early merges that
> Olof did.
> 
> 	Arnd

