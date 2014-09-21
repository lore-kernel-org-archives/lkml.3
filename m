Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaIUT2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:28:18 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:46315 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbaIUT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:28:17 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2014 15:28:17 EDT
Date: Sun, 21 Sep 2014 21:19:19 +0200
From: Waldemar Brodkorb <mail@waldemar-brodkorb.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [RFC PATCH 8/8] Revert "percpu: free percpu allocation info for
 uniprocessor system"
Message-ID: <20140921191919.GS14691@waldemar-brodkorb.de>
Reply-To: Waldemar Brodkorb <mail@waldemar-brodkorb.de>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
 <1411316838-15135-9-git-send-email-linux@roeck-us.net>
 <1C04F98F-4DA4-4038-B1D1-930BBC592147@axis.com>
 <541F1AFF.9040509@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541F1AFF.9040509@roeck-us.net>
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,
Guenter Roeck wrote,

> On 09/21/2014 10:23 AM, Mikael Starvik wrote:
> >Thanks for all your work with CRIS! CRISv10 is alive but is currently used as small helper CPUs close to hardware blocks.
> >
> 
> You are welcome. Now it would be even better if we could get the upstream code to work
> with qemu. Which leads to the questions - is CRISv32 alive, and is there a chance
> to get there ? Also, if CRISv10 is alive, is there any interest or even benefit to
> maintain it in the latest kernel ? Because if not, we might as well drop v10 support
> to simplify kernel maintenance.

Please do not drop crisv10 support.
Don't kill my foxboard lx cluster ;)

http://www.openadk.org/cris/cris1.jpg
http://www.openadk.org/cris/cris2.jpg

best regards, 
 Waldemar
 
