Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaJ1Ovg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:51:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaJ1Ovf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:51:35 -0400
Date: Tue, 28 Oct 2014 22:50:22 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 03/11] drivers: char: add AXD Audio Processing IP driver
Message-ID: <20141028145022.GA19843@kroah.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-4-git-send-email-qais.yousef@imgtec.com>
 <20141028141038.GA18384@kroah.com>
 <544FA9F7.1020101@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FA9F7.1020101@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 02:36:39PM +0000, Qais Yousef wrote:
> On 10/28/2014 02:10 PM, Greg Kroah-Hartman wrote:
> >On Tue, Oct 28, 2014 at 11:26:21AM +0000, Qais Yousef wrote:
> >>AXD is Audio Processing IP by Imagination Technologies that can
> >>perform decoding, encoding, equalisation, resampling, mixing,
> >>synchronisation and audio playback.
> >Isn't that a codec?  Why is this a "char" driver and not one that fits
> >into our existing audio subsystem?
> 
> As far as I understand it doesn't fit into current alsa framework because of
> a number of unsupported features that we need. Specifically the range of
> compressed decoders we support and their configurations and encoding. I
> might have gotten it wrong though so I'll wait to see what alsa people say.

Then add the new features you need and everyone benefits.

Please work with the alsa developers on this, I will not accept anything
until they say there is no way this will work, and they bless a custom
one-off interface like this.

thanks,

greg k-h
