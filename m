Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaGJOyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:54:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:54:38 -0400
Date: Thu, 10 Jul 2014 07:54:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: B_B_Singh@DELL.com
Cc: tiwai@suse.de, Abhay_Salunke@DELL.com, arnd@arndb.de, kay@vrfy.org,
        ming.lei@canonical.com, sr@denx.de, teg@jklm.no, Stuart_Hayes@DELL.com,
        Srinivas_G_Gowda@DELL.com, linux-kernel@vger.kernel.org
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
Message-ID: <20140710145417.GB18412@kroah.com>
References: <14048583172593@kroah.com>
 <8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
 <20140710143144.GA17639@kroah.com>
 <8B2F6FFD0BD1E448853114367400A37306FD6FBBF0@BLRX7MCDC203.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8B2F6FFD0BD1E448853114367400A37306FD6FBBF0@BLRX7MCDC203.AMER.DELL.COM>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 08:10:01PM +0530, B_B_Singh@DELL.com wrote:
> Resending the mail..
> 
> Hi All,
> 
> As I communicated earlier the test never passed with older BIOS DUPs.

That test?  What patch?  Please be explicit, I deal with thousands of
patches and have no short term memory...

> Again today I have tested with 3.15.5 kernel with below patch applied,
> & I don't see the BIOS getting updated. The BIOS update always failed
> with below patch.  
> 
> I'm not sure why the patch is getting committed even upon failure.

Because in that long and winding email thread I thought you said this
patch _worked_.  Obviously I was wrong, sorry, please suggest an
alternative.

greg k-h
