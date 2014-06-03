Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaFCJoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:44:25 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40499 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFCJoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:44:24 -0400
Message-ID: <1401788659.18466.2.camel@linux-fkkt.site>
Subject: Re: [PATCH] MAINTAINERS: drop two usb-serial subdriver entries
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Jun 2014 11:44:19 +0200
In-Reply-To: <20140602071607.GD14935@localhost>
References: <1401615137-11862-1-git-send-email-jhovold@gmail.com>
	 <20140601174559.GB1281@kroah.com> <20140602071607.GD14935@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 09:16 +0200, Johan Hovold wrote:
> Oliver and perhaps also Mathias are still around, but the option
> driver
> is now down to about 200 LOC (including boilerplate) when not counting
> the id table, while the kl5kusb105 is currently at about 400 LOC
> (including boilerplate) since I converted it to use the generic
> implementation a few years ago.
> 
> Oliver and Mathias, what do you think of this? Would you be willing to
> sign off on this patch?

Signed-off-by: Oliver Neukum <oliver@neukum.org>

	Regards
		Oliver


