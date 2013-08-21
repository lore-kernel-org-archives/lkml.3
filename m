Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3HUQZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:25:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3HUQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:25:08 -0400
Date: Wed, 21 Aug 2013 09:25:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: j.dumon@option.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hso: Earlier catch of error condition
Message-ID: <20130821162507.GD14364@kroah.com>
References: <1377074587.4530.8.camel@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377074587.4530.8.camel@chimera>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 01:43:07AM -0700, Daniel Gimpelevich wrote:
> There is no need to get an interface specification if we know it's the
> wrong one. 
> 
> Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
