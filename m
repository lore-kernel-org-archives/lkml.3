Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3BTWYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:24:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47262 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3BTWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:24:36 -0500
Date: Wed, 20 Feb 2013 22:24:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, alan@linux.intel.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH V5 4/5] drivers/amba: add support for a PCI bridge
Message-ID: <20130220222419.GX17833@n2100.arm.linux.org.uk>
References: <cover.1361393832.git.rubini@gnudd.com> <52b9f4e1cc04b7c656e10ee16020090601f6f537.1361393832.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b9f4e1cc04b7c656e10ee16020090601f6f537.1361393832.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:24:02PM +0100, Alessandro Rubini wrote:
> This is a PCI driver that registers AMBA devices for the range of
> supported devices.  It is currently used by STA2X11, which exports
> AMBA peripherals under PCIe.  The original AMBA drivers work with no
> changes or minimal ones.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Alan Cox <alan@linux.intel.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
> 
> @Russell, Alan: I repost this after rebasing, on hpa's suggestion.

I'm happy to take it through my tree if everyone is now happy with this.
