Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaIOCmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:42:53 -0400
Received: from ozlabs.org ([103.22.144.67]:47868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbaIOCmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:42:52 -0400
Message-ID: <1410748970.24738.3.camel@concordia>
Subject: Re: [PATCH v2 1/3] PCI/MSI/PPC: Remove arch_msi_check_device()
From: Michael Ellerman <mpe@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Date: Mon, 15 Sep 2014 12:42:50 +1000
In-Reply-To: <a7a806c4f531ba80386e9d0baf69571a827ea59c.1410078503.git.agordeev@redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
	 <a7a806c4f531ba80386e9d0baf69571a827ea59c.1410078503.git.agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-07 at 20:57 +0200, Alexander Gordeev wrote:
> Moving MSI checks from arch_msi_check_device() function to
> arch_setup_msi_irqs() function makes code more compact and
> allows removing unnecessary hook arch_msi_check_device()
> from generic MSI code.
> 
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-pci@vger.kernel.org
> Cc: Michael Ellerman <mpe@ellerman.id.au>

I already acked the previous version, but if you didn't want it that's fine :)

cheers


