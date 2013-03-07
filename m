Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3CGLfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:35:55 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:45053 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab3CGLfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:35:53 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Samuel Tardieu <sam@rfc1149.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: cdc-acm: Remove obsolete predefined speeds array
Date: Thu, 07 Mar 2013 12:36:15 +0100
Message-ID: <1611226.stnO4heWlu@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.8.0-rc7-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1362652768-23096-1-git-send-email-sam@rfc1149.net>
References: <1362652768-23096-1-git-send-email-sam@rfc1149.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 March 2013 11:39:28 Samuel Tardieu wrote:
> Modern speed handling has been introduced by commit
> 9b80fee149a875a6292b2556ab2c64dc7ab7d6f5 in 2009 and the
> acm_tty_speed array has been unused since.
> 
> Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
Acked-by: Oliver Neukum <oliver@neukum.org>

