Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3LCBPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:15:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54517 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3LCBPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:15:09 -0500
X-AuditID: cbfee68f-b7f336d00000481b-48-529d309b0609
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003b01ceefb6$bca43ed0$35ecbc70$%han@samsung.com>
 <1386028330.15309.13.camel@joe-AO722>
In-reply-to: <1386028330.15309.13.camel@joe-AO722>
Subject: Re: [PATCH 38/39] PCI: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 10:15:06 +0900
Message-id: <003e01ceefc5$1a6f9880$4f4ec980$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vuYdnnBm2Aax/SVWlYGdl6thGxAAClhtw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zI93ZBnODDB42i1ssacqwaF68ns3i
	8sJLrBaz7z9msbi8aw6bxdl5x9kc2DwWbCr12D93DbvHl1XXmD36tqxi9Pi8SS6ANYrLJiU1
	J7MstUjfLoEro3fhT7aCg2wVi2e/Y25gnM3axcjJISFgIvH85h0oW0ziwr31bF2MXBxCAssY
	Jd5MXssGU7SoYToTRGIRo8TjV+dZIJxfjBKn+7eCVbEJqEl8+XKYHcQWEYiQWLL7ACNIEbNA
	B6NEw7t+VoiOmYwSzfPfMHcxcnBwChhJXFnLD9IgLOAisfbZArBBLAKqEqtugqzj5OAVsJVY
	ueMNG4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW/BRkoIqEs8+qsLcYORxNTeX1DlIhL7XrwD
	u0dC4CW7xOWFtxkhdglIfJt8iAWiV1Zi0wFmiI8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYw
	sqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECInZ/h2Mdw9YH2JMBlo/kVlKNDkfGPN5JfGG
	xmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxEvv50p97
	GmdHu6YKN8XbJzJ7yWpoB/MJ2u7TU8mbkK4aNSHEbwWvtozIr+9hBsnr54u0rbNuynz9NuBl
	Jpv/zAmp+oemWYU8S9vc4a9mYebfaJAkqD+N58uCWWteP3E6Pius+bt91HexvlIPmeKQafM7
	mlmvf/96IFY9dvn75WbvjV5dPq7EUpyRaKjFXFScCAAaKql47wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd3ZBnODDBomCFssacqwaF68ns3i
	8sJLrBaz7z9msbi8aw6bxdl5x9kc2DwWbCr12D93DbvHl1XXmD36tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY0bvwp9sBQfZKhbPfsfcwDibtYuRk0NC
	wERiUcN0JghbTOLCvfVsXYxcHEICixglHr86zwLh/GKUON2/lQ2kik1ATeLLl8PsILaIQITE
	kt0HGEGKmAU6GCUa3vWzQnTMZJRonv+GuYuRg4NTwEjiylp+kAZhAReJtc8WgA1iEVCVWHUT
	YjWvgK3Eyh1v2CBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kLNlJCQF3i0V9diBuMJKb2/oIq
	F5HY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	EJ5J72Bc1WBxiFGAg1GJh/fB9jlBQqyJZcWVuYcYJTiYlUR4O3nmBgnxpiRWVqUW5ccXleak
	Fh9iTAZ6dCKzlGhyPjBZ5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhm
	CxMHp1QDo6bsSp+wnxGnT77etV96qYiasfjy4n8cOqsm72IMcVx6fkXBx6hbQty7ls4r7HDO
	0ajjidzTcVtk0cfrgTM2h/bZXyw/cvOJxZJ5os4OO4+nz9jncLw3w+2g4JUW/s2n1IxeH/7l
	fIDn6lfVutXzOtPSWp5+tvdbpn1wUkqG9Pazml/i/7vzmiuxFGckGmoxFxUnAgCU0vSlTAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 8:52 AM, Joe Perches wrote:
> On Tue, 2013-12-03 at 08:32 +0900, Jingoo Han wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred. Also, the definition of DEFINE_PCI_DEVICE_TABLE
> > macro is removed.
> 
> These sorts of treewide conversions are almost never
> applied wholesale.
> 
> This patch is not appropriate until there are no more
> uses of DEFINE_PCI_DEVICE_TABLE in Linus' tree.
> 
> Just marking the function as deprecated in the
> documentation and the pci.h file is probably good
> enough for now.
> 
> see:  http://lkml.org/lkml/2013/12/2/400

Actually, I want to remove all DEFINE_PCI_DEVICE_TABLEs from the
next 3.14-rc1 kernel, by merging all patches through Greg's tree.

Greg,
How about you?

Best regards,
Jingoo Han

