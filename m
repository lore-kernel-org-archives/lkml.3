Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaK0QeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:34:25 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:46661 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaK0QeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:34:24 -0500
Date: Thu, 27 Nov 2014 17:34:14 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 01/45] virtio: use u32, not bitmap for struct
 virtio_device's features
Message-ID: <20141127173414.20424b62@thinkpad-w530>
In-Reply-To: <20141127162804.GB27124@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
	<1417091078-24611-2-git-send-email-mst@redhat.com>
	<20141127171542.3dbb2bc2@thinkpad-w530>
	<20141127162804.GB27124@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112716-0041-0000-0000-00000247BB32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's the whole reason for the patch.
> 
> I guess you disagree with it, but it's much easier
> to deal with simple integers.
> 

Well, I can live with it :)

clear_bit() and friends are just easier to understand when scanning the code
(at least for me).

