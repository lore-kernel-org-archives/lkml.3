Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab3CHPGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:06:22 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:58074 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3CHPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:06:21 -0500
Message-ID: <1362755172.4219.31.camel@thor.lan>
Subject: Re: [PATCH 11/16] crisv10: stop returning info from
 handle_ser_rx_interrupt
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 10:06:12 -0500
In-Reply-To: <1362658360-26629-11-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
	 <1362658360-26629-11-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 13:12 +0100, Jiri Slaby wrote:
> The return value is not used anywhere, so no need to return anything.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/tty/serial/crisv10.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Cc: linux-serial@vger.kernel.org

For all the crisv10.c patches.


