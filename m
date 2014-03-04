Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaCDTEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:04:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaCDTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:04:07 -0500
Date: Tue, 4 Mar 2014 11:05:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julius Werner <jwerner@chromium.org>
Cc: Oliver Neukum <oneukum@suse.de>, Luigi Semenzato <semenzato@chromium.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: Make DELAY_INIT quirk wait 100ms between Get
 Configuration requests
Message-ID: <20140304190550.GB4695@kroah.com>
References: <1393959186-331-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393959186-331-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:53:06AM -0800, Julius Werner wrote:
> The DELAY_INIT quirk only reduces the frequency of enumeration failures
> with the Logitech HD Pro C920 and C930e webcams, but does not quite
> eliminate them. We have found that adding a delay of 100ms between the
> first and second Get Configuration request makes the device enumerate
> perfectly reliable even after several weeks of extensive testing. The
> reasons for that are anyone's guess, but since the DELAY_INIT quirk
> already delays enumeration by a whole second, wating for another 10th of
> that isn't really a big deal for the one other device that uses it, and
> it will resolve the problems with these webcams.
> 
> Change-Id: Ibf738426307fe8ef362768db2decc9bc2b30a930

What am I supposed to do with this line?  :)

