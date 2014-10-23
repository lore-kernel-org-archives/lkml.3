Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaJWJmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaJWJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:42:02 -0400
Date: Thu, 23 Oct 2014 17:40:53 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: russ.dill@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
Message-ID: <20141023094053.GA30334@kroah.com>
References: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:52:24AM -0700, russ.dill@gmail.com wrote:
> From: Russ Dill <Russ.Dill@gmail.com>
> 
> This patch provides the FTDI genuine product verification steps
> as contained within the new 2.12.00 official release. It ensures
> that counterfeiters don't exploit engineering investment made
> by FTDI. Counterfeit ICs are destroying innovation in the
> industry.
> 
> FTDI recommends that to guarantee genuine FTDI products
> please purchase either from FTDI directly or an authorised
> distributor.
> 
> This is definitely not targeting end users - if you're unsure if
> ICs are genuine then please don't use the drivers.
> 
> Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
> ---
>  drivers/usb/serial/ftdi_sio.c | 111 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/usb/serial/ftdi_sio.h |  41 ++++++++++++++++
>  2 files changed, 151 insertions(+), 1 deletion(-)

Funny patch, you should have saved it for April 1, otherwise people
might have actually taken this seriously :)

Patches as performance art, now I've seen everything...

greg k-h
