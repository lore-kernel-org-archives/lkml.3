Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaGISxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:53:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaGISxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:53:14 -0400
Date: Wed, 9 Jul 2014 11:57:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v3] staging: gdm72xx: move T_CAPABILITY definitions to
 hci.h
Message-ID: <20140709185739.GA26312@kroah.com>
References: <53BD88C5.90606@fastmail.fm>
 <1404930682-32298-1-git-send-email-mpappas@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404930682-32298-1-git-send-email-mpappas@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:31:22PM +0100, Michalis Pappas wrote:
> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
> ---
>  drivers/staging/gdm72xx/gdm_wimax.c | 11 +++--------
>  drivers/staging/gdm72xx/hci.h       |  6 ++++++
>  2 files changed, 9 insertions(+), 8 deletions(-)

This no longer applies cleanly either, can you refresh and resend?

thanks,

greg k-h
