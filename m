Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaB0QWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:22:42 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:19700
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbaB0QWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:22:39 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:error;EFVD:FOP
X-SpamScore: 1
X-BigFish: VPS1(z426fnzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1NXHE-08-8Z8-02
X-M-MSG: 
Message-ID: <530F6643.5090009@amd.com>
Date: Thu, 27 Feb 2014 10:22:27 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <dougthompson@xmission.com>, <bhelgaas@google.com>,
        <JBeulich@suse.com>, <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <Arindam.Nath@amd.com>
Subject: Re: [PATCH] amd64_edac: Add support for newer F16h models
References: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140221142749.GC11531@pd.tnic> <5307BF6F.8040303@amd.com> <20140224140931.GA16457@pd.tnic>
In-Reply-To: <20140224140931.GA16457@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/2014 8:09 AM, Borislav Petkov wrote:
> On Fri, Feb 21, 2014 at 03:04:47PM -0600, Aravind Gopalakrishnan wrote:
>> F{3,4} are used by hwmon/k10temp.c and hwmon/fam15h_power.c and they
>> will need definitions to be places here in pci_ids.h But I'm not sure
>> if the hwmon drivers need to carry support for this model yet (will
>> verify that)
>>
>> If not, I'll remove them and resend.
> Yes, please check that and let me know.
>
>
Ok, here's more info: we will need to add support in k10temp for this 
model; and support is
not required in fam15h_power as register bits used by the driver code 
are unavailable for OS.
But F{3,4} usage is split: k10temp uses F3 device ID and fam15h_power 
uses F4 device ID.

Not sure if you want to split these definitions between amd_nb.h and 
pci_ids.h or just let it be.

Thanks,
-Aravind.




