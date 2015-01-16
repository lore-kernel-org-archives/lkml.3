Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbbAPMMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:12:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbbAPMM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:12:27 -0500
Message-ID: <54B90027.5040103@suse.de>
Date: Fri, 16 Jan 2015 13:12:23 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] current ACCESS_ONCE patch queue
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 15.01.15 09:58, Christian Borntraeger wrote:
> Folks,
> 
> fyi, this is my current patch queue for the next merge window. It
> does contain a patch that will disallow ACCESS_ONCE on non-scalar
> types.
> 
> The tree is part of linux-next and can be found at
> git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git linux-next

KVM PPC bits are:

 Acked-by: Alexander Graf <agraf@suse.de>



Alex
