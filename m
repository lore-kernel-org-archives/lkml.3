Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab3FXMtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:49:16 -0400
Received: from plane.gmane.org ([80.91.229.3]:40996 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3FXMtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:49:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: SATA hdd refuses to reallocate a sector?
Date: Mon, 24 Jun 2013 14:48:56 +0200
Message-ID: <51C84038.6090507@gmail.com>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip-94-113-17-106.net.upcbroadband.cz
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
In-Reply-To: <20130623101940.GA4448@amd.pavel.ucw.cz>
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 12:19 PM, Pavel Machek wrote:
> Hi!
> 
> This may very well be hw problem, but...
> 
> I have error on sda4. I tried to make hdd reallocate it by writing
> zeros there, but it will not. Is there special kind of write that
> needs to be done to force reallocation?

Hi Pavel, maybe smartctl -t long /dev/sda will do the trick reliable for
your drive..

Z.

