Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaJWIYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:24:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45746 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaJWIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:24:50 -0400
Date: Thu, 23 Oct 2014 10:24:44 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
Message-ID: <20141023082444.GA4122@localhost.localdomain>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
 <1414037002-25528-7-git-send-email-linux@roeck-us.net>
 <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
 <54488CE1.2000106@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54488CE1.2000106@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:06:41PM -0700, Guenter Roeck wrote:
> On 10/22/2014 09:37 PM, Florian Fainelli wrote:
> >You probably want the number of temperature sensors to come from the
> >switch driver, and support arbitrary number of temperature sensors?
> 
> In that case we would need the number of sensors, pass a sensor index,
> and create a dynamic number of attributes. The code would get much more
> complex without real benefit unless there is such a chip - and if there is,
> we can still change the code at that time. I would prefer to keep it simple
> for now.

Better to do it correctly, right from the start. There *will* be such
a chip one day, and the person wanting to add it will appreciate the
solid foundation (even if that person ends up being you ;).

Thanks,
Richard
