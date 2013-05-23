Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3EWQ6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:58:14 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2119
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758708Ab3EWQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:58:11 -0400
X-Forefront-Antispam-Report: CIP:157.56.238.53;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0712HT004.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519E4A98.7020903@caviumnetworks.com>
Date: Thu, 23 May 2013 09:58:00 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        Sanjay Lal <sanjayl@kymasys.com>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v5 0/6] mips/kvm: Fix ABI for compatibility with 64-bit
 guests.
References: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com> <20130523102834.GN4725@redhat.com>
In-Reply-To: <20130523102834.GN4725@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 03:28 AM, Gleb Natapov wrote:
> On Wed, May 22, 2013 at 11:43:50AM -0700, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
> Please regenerate against master. arch/mips/include/asm/kvm.h does not
> exists any more.

New patch sent.  I gather from this message, that you want to merge this 
particular set via your tree instead of Ralf's MIPS tree.  That's fine 
with me.  However, we were hoping to have these ABI fixing patches 
pushed to Linus before 3.10 releases, so that there don't exist kernel 
versions with the defective ABI.

Future patch sets may affect core MIPS architecture files, and therefore 
may not be so amenable to merging via the KVM tree.  We will have to 
figure out how to handle that.

David Daney



