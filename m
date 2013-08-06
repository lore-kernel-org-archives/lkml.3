Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3HFU7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:59:21 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:37710
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996Ab3HFU7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:59:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2dI98dI9371I103dK1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh783m1155h)
X-WSS-ID: 0MR4NMP-01-9ED-02
X-M-MSG: 
Message-ID: <520163A1.6040901@amd.com>
Date: Tue, 6 Aug 2013 15:59:13 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3 V2] EDAC, AMD64_EDAC: Add PCI Device ID Functions
 3 and 4 for newer F15h models.
References: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <1375483384-2302-2-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130806201742.GF14891@pd.tnic>
In-Reply-To: <20130806201742.GF14891@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/2013 3:17 PM, Borislav Petkov wrote:
> On Fri, Aug 02, 2013 at 05:43:02PM -0500, Aravind Gopalakrishnan wrote:
>> Adding PCI_DEVICE_ID_AMD_15H_NB_M30H_F3 and PCI_DEVICE_ID_AMD_15H_NB_M30H_F4
>> for F15h model 30h. This is required for the file amd_nb.c
> ... and amd64_edac.c
>
> Also, remember to read the comment at the beginning of
> include/linux/pci_ids.h!
>
> I fixed up the commit message when applying.
>
Okay, Thanks!

