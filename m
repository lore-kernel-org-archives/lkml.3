Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3LCCoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:44:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23626 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LCCoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:44:18 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-c0-529d45805395
From: Jingoo Han <jg1.han@samsung.com>
To: "'Stephen Hemminger'" <stephen@networkplumber.org>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'David Miller'" <davem@davemloft.net>,
        netdev@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Jonas Bonn'" <jonas@southpole.se>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <002901ceefb4$f1191e30$d34b5a90$%han@samsung.com>
 <20131202183646.459564a9@nehalam.linuxnetplumber.net>
In-reply-to: <20131202183646.459564a9@nehalam.linuxnetplumber.net>
Subject: Re: [PATCH 20/39] net: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 11:44:16 +0900
Message-id: <004601ceefd1$8efd6ea0$acf84be0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7v0IVcCPJy9qYbRw6D+nPOLIiUAAAAAkdA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zI90G17lBBvfPmlnMOd/CYtG8eD2b
	xeWFl1gtZt9/zGLxZ+YHJovLu+awWRxbIGax+I6cA4fHlpU3mTz2z13D7tFzch6Tx5dV15g9
	+rasYvQ41bOa2ePzJrkA9igum5TUnMyy1CJ9uwSujL5Hn1kKlvNUzHu6g7WBsZWri5GTQ0LA
	ROLBqunsELaYxIV769m6GLk4hASWMUp8mzSVHaZo06m5rBCJ6YwStz5vYIJwfjFK7Pi7ngWk
	ik1ATeLLl8NAHRwcIkAdXZdTQMLMAv8ZJQ4+M4WoX8ko8fH6HbCpnAJOEpePbmICqRcWcJG4
	tF4JJMwioCrxaMkZsJG8ArYSHx88ZoKwBSV+TL7HAjFTS2L9zuNMELa8xOY1b5lBxkgIqEs8
	+qsLEhYRMJLoWPqADaJERGLfi3eMICdICDRySLw+f54RYpeAxLfJh1ggemUlNh1ghvhXUuLg
	ihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJC47tvB
	ePOA9SHGZKD1E5mlRJPzgWkhryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwtt/dsbYoOmj2346dP03FM3alni5gybwX98g5hvnzL1OmJuOz1bbJ
	Fw5kT1Izff8prlg2wDVnZZ7IYcacT60n16yVnf+Ol7ned07Pu9W7js+Q/JK7c59VDfP6z9t3
	275lML2RGa92/EplKme12wKji+pGRVnv0ydVKnc8igW6MCn9aveJr41KLMUZiYZazEXFiQCd
	fj7dAQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQd0G17lBBodXGFnMOd/CYtG8eD2b
	xeWFl1gtZt9/zGLxZ+YHJovLu+awWRxbIGax+I6cA4fHlpU3mTz2z13D7tFzch6Tx5dV15g9
	+rasYvQ41bOa2ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBl9
	jz6zFCznqZj3dAdrA2MrVxcjJ4eEgInEplNzWSFsMYkL99azdTFycQgJTGeUuPV5AxOE84tR
	Ysff9SwgVWwCahJfvhxm72Lk4BAB6u66nAISZhb4zyhx8JkpRP1KRomP1++wgyQ4BZwkLh/d
	xARSLyzgInFpvRJImEVAVeLRkjNgI3kFbCU+PnjMBGELSvyYfI8FYqaWxPqdx5kgbHmJzWve
	MoOMkRBQl3j0VxckLCJgJNGx9AEbRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4KTxTHoH46oGi0OMAhyMSjy8D7bPCRJiTSwrrsw9xCjB
	wawkwtvJMzdIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBCS2vJN7Q2MTMyNLIzMLIxNyc
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilgDF66VJNdrfkqucsktYfN5UWWrCFv9NQf72h
	/8OynG91EaUvxZ4EsPc9lhMwKcs8nrL7/G6dlYazzRR/MG7kv71k4R85hjIjb0PBipWSTvJv
	ii5+7Qm8m/2+2PCUpJSsfSqr0Bv2c1K/0ri+d75W4I3L8JLYPiX9wx/ji59NRbl8toh/0F3z
	XomlOCPRUIu5qDgRAMc+lWteAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 11:37 AM, Stephen Hemminger wrote:
> On Tue, 03 Dec 2013 08:19:25 +0900
> Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Perhaps a little more explanation why it is not preferred.
> Not everyone tracks LKML or the PCI list.

(+cc Joe Perches, Jonas Bonn)

It is simple.
There is no special reason to use DEFINE_PCI_DEVICE_TABLE macro.

According to the Greg Kroah-Hartman,
"Yeah, and it's a horrid macro that deserves to be removed,
please don't use it in more places."

Currently, there is no other bus that has something like this
macro for their device ids. Thus, DEFINE_PCI_DEVICE_TABLE macro
should be removed.

Jonas Bonn (author of DEFINE_PCI_DEVICE_TABLE macro) also agreed
to remove this macro. According to Jonas Bonn,
"Actually, I think I submitted an even uglier macro called 
DECLARE_PCI_DEVICE_TABLE... might have been the first kernel
Patch I  ever sent?  In any case, it should certainly have been
kindly rejected."

After Joe Perches's patch[1] is merged, I will send these patches
to each subsystem maintainer.

[1][PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
    (http://lkml.org/lkml/2013/12/2/400)

In this patch, Joe Perches fixed 'Documentation/PCI/pci.txt', and
'scripts/checkpatch.pl', in order to guide to use 'struct pci_device_id'
instead of 'DEFINE_PCI_DEVICE_TABLE' macro.

Thank you.

Best regards,
Jingoo Han

