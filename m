Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3FQQgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:36:00 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:62643 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3FQQf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:35:57 -0400
Message-ID: <51BF3AE6.3070805@redhat.com>
Date: Mon, 17 Jun 2013 18:35:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru> <1370412673-1345-5-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1370412673-1345-5-git-send-email-aik@ozlabs.ru>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/06/2013 08:11, Alexey Kardashevskiy ha scritto:
> +/*
> + * The KVM guest can be backed with 16MB pages (qemu switch
> + * -mem-path /var/lib/hugetlbfs/global/pagesize-16MB/).

Nitpick: we try to avoid references to QEMU, so perhaps

s/qemu switch/for example, with QEMU you can use the command-line option/

Paolo
