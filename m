Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbaFTXQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:16:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:59778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbaFTXQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:16:35 -0400
Message-ID: <1403306175.4587.68.camel@pasglop>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Date: Sat, 21 Jun 2014 09:16:15 +1000
In-Reply-To: <53A441D3.8010602@ozlabs.ru>
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
	 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>
	 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>
	 <1403234514.3707.278.camel@ul30vt.home> <53A441D3.8010602@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-21 at 00:14 +1000, Alexey Kardashevskiy wrote:

> We can still use __raw_writel&co, would that be ok?

No unless you understand precisely what kind of memory barriers each
platform require for these.

Cheers,
Ben.


