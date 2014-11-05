Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaKEWuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:50:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaKEWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:50:49 -0500
Date: Wed, 5 Nov 2014 14:50:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
Message-ID: <20141105225049.GA12361@kroah.com>
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D882601ABA4@P3PWEX4MB008.ex4.secureserver.net>
 <5454086D.6000401@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D882601B051@P3PWEX4MB008.ex4.secureserver.net>
 <545412F3.60502@mev.co.uk>
 <545414A6.9090101@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545414A6.9090101@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:00:54PM +0000, Ian Abbott wrote:
> On 31/10/14 22:53, Ian Abbott wrote:
> >I like the idea of the core comedi module being separated from all the
> >various buses. And other buses can be added easily without pulling extra
> >dependencies into the core (e.g. for platform or spi devices).
> 
> And if this get's accepted, I'd like to complete the separation by moving
> the PCI, USB and PCMCIA stuf out of the "comedidev.h" header into their own
> headers, which obviously means small edits to most of the low-level drivers
> to #include different headers. (But then, "comedi_pci.h" could #include
> <linux/pci.h> for example.)

Hartley, any objection to me applying this series?

greg k-h
