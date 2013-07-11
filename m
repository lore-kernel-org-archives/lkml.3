Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3GKNoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:44:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3GKNoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:44:09 -0400
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel handling
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <51DEB5F0.3000502@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 15:44:01 +0200
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <82D6488B-C6D7-475F-A16B-FC8AAC9E76A0@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-9-git-send-email-aik@ozlabs.ru>	 <51DC4923.5010501@suse.de> <51DE7377.1060503@ozlabs.ru>	 <902F79B9-BB81-40A0-865D-94E7108DAC5E@suse.de> <1373546233.19894.85.camel@pasglop> <B526C260-1ADB-4B9F-B80A-46E5A9E53FF6@suse.de> <1373547392.19894.100.camel@pasglop> <51DEB5F0.3000502@linux.vnet.ibm.com>
To: chandrashekar shastri <cshastri@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.07.2013, at 15:41, chandrashekar shastri wrote:

> Hi All,
> 
> I complied the latest kernel 3.10.0+ pulled from the git on top of  3.10.0-rc5+ by enabling the new Virtualiztaion features. The compliation was sucessfull, when I rebooted the machine it fails to boot with error as " systemd [1] : Failed to mount /dev : no such device.
> 
> Is it problem with the KVM module?

Very unlikely. You're probably missing generic config options in your .config file. But this is very off topic for a) this thread and b) these mailing lists.


Alex

