Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3GKNlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:41:18 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52051 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3GKNlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:41:16 -0400
Message-ID: <51DEB5F0.3000502@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 19:11:04 +0530
From: chandrashekar shastri <cshastri@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alexander Graf <agraf@suse.de>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-9-git-send-email-aik@ozlabs.ru>	 <51DC4923.5010501@suse.de> <51DE7377.1060503@ozlabs.ru>	 <902F79B9-BB81-40A0-865D-94E7108DAC5E@suse.de> <1373546233.19894.85.camel@pasglop> <B526C260-1ADB-4B9F-B80A-46E5A9E53FF6@suse.de> <1373547392.19894.100.camel@pasglop>
In-Reply-To: <1373547392.19894.100.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071113-8256-0000-0000-0000084CB2BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I complied the latest kernel 3.10.0+ pulled from the git on top of  
3.10.0-rc5+ by enabling the new Virtualiztaion features. The compliation 
was sucessfull, when I rebooted the machine it fails to boot with error 
as " systemd [1] : Failed to mount /dev : no such device.

Is it problem with the KVM module?

Thanks,
Shastri

On 07/11/2013 06:26 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-07-11 at 14:50 +0200, Alexander Graf wrote:
>>> Not really no. But that would do. You could have give a more useful
>>> answer in the first place though rather than stringing him along.
>> Sorry, I figured it was obvious.
> It wasn't no, because of the mess with modules and the nasty Makefile we
> have in there. Even I had to scratch my head for a bit :-)
>
> Ben.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

