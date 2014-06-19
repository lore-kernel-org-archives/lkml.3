Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650AbaFSVLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:11:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46678 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934434AbaFSVLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:11:23 -0400
X-Sasl-enc: JjS5vbeZ2c5ziG4hzTmCv/JUUcvxtJiDFAJAAXYrWicr 1403212282
Date: Thu, 19 Jun 2014 14:15:22 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH 0/2] thunderbolt: Fix issues with more complex endpoints.
Message-ID: <20140619211522.GA14136@kroah.com>
References: <1402607507-14858-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402607507-14858-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:11:45PM +0200, Andreas Noever wrote:
> Hi,
> 
> I have got my hand on a slightly more complex Thunderbolt device (a Startech
> docking station). This series fixes the following issues that I have observed
> with this device:
> 
>  - Some ports on this device are disabled. Accessing them results in an error.
>  - This device uses both Thunderbolt links which are represented as two ports on
>    the switch. We have to ensure that we only scan one of these ports.
> 
> Part 1 of the series reads the switch configuration (disabled ports and which
> port pairs are "dual link ports") from eeprom. Part 2 uses this information to
> avoid scanning these ports.
> 
> Andreas Noever (2):
>   thunderbolt: Read port configuration from eeprom.
>   thunderbolt: Fix nontrivial endpoint devices.

Applied, thanks.

greg k-h
