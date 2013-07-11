Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3GKNqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:46:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53132 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3GKNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:46:42 -0400
Message-ID: <51DEB73B.9090702@ozlabs.ru>
Date: Thu, 11 Jul 2013 23:46:35 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: chandrashekar shastri <cshastri@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-9-git-send-email-aik@ozlabs.ru>	 <51DC4923.5010501@suse.de> <51DE7377.1060503@ozlabs.ru>	 <902F79B9-BB81-40A0-865D-94E7108DAC5E@suse.de> <1373546233.19894.85.camel@pasglop> <B526C260-1ADB-4B9F-B80A-46E5A9E53FF6@suse.de> <1373547392.19894.100.camel@pasglop> <51DEB5F0.3000502@linux.vnet.ibm.com>
In-Reply-To: <51DEB5F0.3000502@linux.vnet.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 11:41 PM, chandrashekar shastri wrote:
> Hi All,
> 
> I complied the latest kernel 3.10.0+ pulled from the git on top of 
> 3.10.0-rc5+ by enabling the new Virtualiztaion features. The compliation
> was sucessfull, when I rebooted the machine it fails to boot with error as
> " systemd [1] : Failed to mount /dev : no such device.
> 
> Is it problem with the KVM module?


Wrong thread actually, would be better if you started the new one.

And you may want to try this - http://patchwork.ozlabs.org/patch/256027/


-- 
Alexey
