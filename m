Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaEUTjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:39:10 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57706 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaEUTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:39:08 -0400
Date: Wed, 21 May 2014 21:39:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140521193905.GN1873@two.firstfloor.org>
References: <20140519211719.GA14563@logfs.org>
 <8761l0r6nc.fsf@tassilo.jf.intel.com>
 <20140520200803.GA22308@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520200803.GA22308@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think leaking of private keys or similar information is not a
> concern.  But please prove me wrong.  Better you now than someone else
> later.

While I don't have a concrete exploit it seems seems dangerous to me. 
The LibreSSL people just removed a similar behavior from OpenSSL.

-Andi
