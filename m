Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3CYLjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:39:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3CYLi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:38:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH 2/3] serial: of_serial: Handle fifo-size property
Date: Mon, 25 Mar 2013 11:38:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com> <1364211286-31611-3-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1364211286-31611-3-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251138.52425.arnd@arndb.de>
X-Provags-ID: V02:K0:uVLRcKtK+3f3dSMeE45XzibiQrfiEWDCrqVwgwqZx9c
 mmlsa0urYmHoAbq4VvanWHRk+ZAz/Xuk+5C/ooJrVNab3VoH2B
 /+bJva2d2DefAcO+VksEeFCaDZyJZ+VmYUbE6A556Ej7smOHbR
 c47jD8kJryTi8IWEf0QxIhy6WkDOhHuQe4lxIrtTazzFXNu2RB
 onBJ5eYrS1UEnrVXygjKdRlXdWO+50ChVvgVNWW/AE2KHHS4BQ
 hqo9+K+B+Cs+8tGENUY+bLp4urpWxM435j2ApxsmPqTlLCr3Nl
 kXVR/sWFE3Z8gA3MGzXgq8cI6Y+a1GPzdIyZVA5J/HFZ06/imV
 uh1IhHJZffek4aMxeY9g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Heikki Krogerus wrote:
> 
> This will reduce the need for extra types in 8250.c just
> in case the fifo size differs from the standard.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
