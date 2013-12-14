Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3LNV7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:59:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3LNV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:59:48 -0500
Date: Sat, 14 Dec 2013 14:01:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to reserve pci bus numbers for hotplug?
Message-ID: <20131214220145.GA27585@kroah.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 12:37:50AM +0100, Andreas Noever wrote:
> 
> If I could get Linux to assign enough resources (bus numbers for now)
> then I could drop the acpi_osi parameter and make thunderbolt work
> after suspend... So, is there an easy way to fix this? (Quirks,
> reconfiguring bus number assignments from a platform driver, ...?)

I think you are going to have to do a lot more here, what is needed is a
whole connection manager for Thunderbolt, emulating what the BIOS does,
in order to get all of this working properly.

But don't let that stop you from trying, however the work involved is
really not trivial at all.

good luck,

greg k-h
