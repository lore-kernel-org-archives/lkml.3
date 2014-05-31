Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaEaRvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 13:51:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40270 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbaEaRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 13:51:46 -0400
X-Sasl-enc: KX2iM/6NSX0xUtMFkjYn+NhJNLDUlBAwodXQNG54SmG7 1401558702
Date: Sat, 31 May 2014 10:51:40 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Message-ID: <20140531175140.GA28745@kroah.com>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 04:27:45PM +0200, Andreas Noever wrote:
> Hi
> 
> This is version 4 of my Thunderbolt driver for Apple hardware (see [1] for v3).
> 
> Changes since v3:
>  - Fix typos and style problems caught by Bjorn.
>  - Changed the #ifdef CONFIG_ACPI block to cover the whole pci quirk.

Looks good, want me to take this through my tree?  Matthew, any
objections?

thanks,

greg k-h
