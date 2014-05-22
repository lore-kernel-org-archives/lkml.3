Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaEVNbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:31:45 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37247 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaEVNbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:31:44 -0400
Date: Thu, 22 May 2014 15:31:22 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mips@linux-mips.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: MSP71xx: remove checks for two macros
Message-ID: <20140522133121.GD10287@linux-mips.org>
References: <1400751291.16832.27.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400751291.16832.27.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:34:51AM +0200, Paul Bolle wrote:

> Since v2.6.39 there are checks for CONFIG_MSP_HAS_DUAL_USB and checks
> for CONFIG_MSP_HAS_TSMAC in the code. The related Kconfig symbols have
> never been added. These checks have evaluated to false for three years
> now. Remove them and the code they have been hiding.

Queued for 3.16.

  Ralf
