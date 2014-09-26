Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaIZXYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:24:24 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:49210 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbaIZXYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:24:23 -0400
Message-ID: <1411773829.14568.15.camel@linux-t7sj.site>
Subject: Re: [PATCH] partitions: efi.c: fix formatting and function
 readability
From: Davidlohr Bueso <dave@stgolabs.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: Joseph Poirier <jdpoirier@gmail.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 16:23:49 -0700
In-Reply-To: <20140926155356.GY18635@console-pimps.org>
References: <1409803640-9682-1-git-send-email-jdpoirier@gmail.com>
	 <20140926155356.GY18635@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 16:53 +0100, Matt Fleming wrote:
> (No response from Davidlohr, try another address)
> 
> On Wed, 03 Sep, at 11:07:20PM, Joseph Poirier wrote:
> > From: jpoirier <jdpoirier@gmail.com>
> > 
> > Fixed coding style issues, refactored the protective MBR check
> > function for readability, and removed an explicit return from a
> > function returning void.

Apologies for the late reply, I had not seen this.

This patch does too much, mind sending a series instead?

Thanks,
Davidlohr

